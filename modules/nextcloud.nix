{ config, lib, ... }:

let
  nextcloudCertName = config.my.nextcloudDomain;
  nextcloudCertPath = "/var/lib/acme/${nextcloudCertName}";
  nextcloudOcc = lib.getExe config.services.nextcloud.occ;
in

{
  security.acme = {
    acceptTerms = true;
    defaults.email = config.my.acmeEmail;

    certs.${nextcloudCertName} = {
      domain = config.my.nextcloudDomain;
      extraDomainNames = [ config.my.collaboraDomain ];
      dnsProvider = "cloudflare";
      credentialFiles."CF_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-dns-api-token.path;
      group = "nginx";
    };
  };

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
    useACMEHost = nextcloudCertName;
    forceSSL = true;
  };

  services.collabora-online = {
    enable = true;
    settings = {
      server_name = "${config.my.collaboraDomain}:443";
      net.post_allow.host = [
        "https://${config.my.nextcloudDomain}"
        "https://${config.my.collaboraDomain}"
        "127\\.0\\.0\\.1"
        "::1"
      ];
    };
    aliasGroups = [
      {
        host = "https://${config.my.collaboraDomain}:443";
        aliases = [ ];
      }
    ];
  };

  services.nginx.virtualHosts.${config.my.collaboraDomain} = {
    useACMEHost = nextcloudCertName;
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
      ${nextcloudOcc} config:app:set richdocuments wopi_allowlist --value="192.168.0.200,127.0.0.1,::1"
      ${nextcloudOcc} config:app:set richdocuments wopi_callback_url --value="https://${config.my.nextcloudDomain}"
      ${nextcloudOcc} config:system:set allow_local_remote_servers --type bool --value true
      ${nextcloudOcc} richdocuments:activate-config --wopi-url "https://${config.my.collaboraDomain}" --callback-url "https://${config.my.nextcloudDomain}"
      ${nextcloudOcc} app:disable richdocumentscode richdocumentscode_arm64 || true
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}