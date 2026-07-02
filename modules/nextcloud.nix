{ config, pkgs, lib, ... }:

let
  localCa = pkgs.runCommandLocal "local-ca" { nativeBuildInputs = [ pkgs.openssl ]; } ''
    mkdir -p "$out"
    openssl genrsa -out "$out/ca.key" 4096
    openssl req -x509 -new -nodes -key "$out/ca.key" \
      -out "$out/ca.pem" \
      -subj "/CN=themoser-local-ca" \
      -days 3650
    chmod 0644 "$out/ca.key" "$out/ca.pem"
  '';

  localCert = domain: name: pkgs.runCommandLocal "${name}-local-cert" { nativeBuildInputs = [ pkgs.openssl ]; } ''
    mkdir -p "$out"
    cat > openssl.cnf <<EOF
    [req]
    distinguished_name = req_distinguished_name
    x509_extensions = v3_req
    prompt = no

    [req_distinguished_name]
    CN = ${domain}

    [v3_req]
    subjectAltName = @alt_names

    [alt_names]
    DNS.1 = ${domain}
    IP.1 = 192.168.0.200
    EOF

    openssl genrsa -out "$out/key.pem" 4096
    openssl req -new -key "$out/key.pem" -out "$out/request.csr" -config openssl.cnf

    openssl x509 -req \
      -in "$out/request.csr" \
      -CA ${localCa}/ca.pem \
      -CAkey ${localCa}/ca.key \
      -CAserial ca.srl \
      -CAcreateserial \
      -out "$out/cert.pem" \
      -days 3650 \
      -extfile openssl.cnf \
      -extensions v3_req
  '';

  nextcloudCert = localCert config.my.nextcloudDomain "nextcloud";
  collaboraCert = localCert config.my.collaboraDomain "collabora";
  nextcloudOcc = lib.getExe config.services.nextcloud.occ;
in

{
  security.pki.certificates = [
    (builtins.readFile "${localCa}/ca.pem")
  ];

  services.nextcloud = {
    enable = true;
    hostName = config.my.nextcloudDomain;
    https = true;

    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
    };

    settings = {
      trusted_domains = [ config.my.nextcloudDomain ];
      trusted_proxies = [ "127.0.0.1" "::1" ];
      overwriteprotocol = "https";
      "overwrite.cli.url" = "https://${config.my.nextcloudDomain}";
      allow_local_remote_servers = true;
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit richdocuments;
    };

    extraAppsEnable = true;
  };

  services.nginx.virtualHosts.${config.my.nextcloudDomain} = {
    sslCertificate = "${nextcloudCert}/cert.pem";
    sslCertificateKey = "${nextcloudCert}/key.pem";
    forceSSL = true;
  };

  services.collabora-online = {
    enable = true;
    settings = {
      net.post_allow.host = [
        "https://${config.my.nextcloudDomain}"
        "https://${config.my.collaboraDomain}"
        "127\\.0\\.0\\.1"
        "::1"
      ];
    };
    aliasGroups = [
      {
        host = "https://${config.my.nextcloudDomain}";
        aliases = [ ];
      }
    ];
  };

  services.nginx.virtualHosts.${config.my.collaboraDomain} = {
    sslCertificate = "${collaboraCert}/cert.pem";
    sslCertificateKey = "${collaboraCert}/key.pem";
    forceSSL = true;
    locations."/" = {
      proxyPass = "https://127.0.0.1:${toString config.services.collabora-online.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_ssl_verify off;
        proxy_ssl_server_name on;
      '';
    };
  };

  systemd.services.nextcloud-richdocuments-config = {
    description = "Configure Nextcloud richdocuments for local Collabora";
    after = [
      "nextcloud-setup.service"
      "coolwsd.service"
      "nginx.service"
    ];
    wants = [
      "coolwsd.service"
      "nginx.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
    script = ''
      ${nextcloudOcc} config:app:set richdocuments wopi_url --value="https://${config.my.collaboraDomain}"
      ${nextcloudOcc} config:app:set richdocuments public_wopi_url --value="https://${config.my.collaboraDomain}"
      ${nextcloudOcc} config:app:set richdocuments wopi_callback_url --value="https://${config.my.nextcloudDomain}"
      ${nextcloudOcc} config:system:set allow_local_remote_servers --type bool --value true
      ${nextcloudOcc} richdocuments:activate-config --wopi-url "https://${config.my.collaboraDomain}" --callback-url "https://${config.my.nextcloudDomain}"
      ${nextcloudOcc} app:disable richdocumentscode richdocumentscode_arm64 || true
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}