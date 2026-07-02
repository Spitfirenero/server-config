{ config, pkgs, ... }:

let
  localCert = pkgs.runCommandLocal "nextcloud-local-cert" { nativeBuildInputs = [ pkgs.openssl ]; } ''
    mkdir -p "$out"
    openssl req -x509 -newkey rsa:4096 -nodes \
      -keyout "$out/key.pem" \
      -out "$out/cert.pem" \
      -subj "/CN=${config.my.nextcloudDomain}" \
      -days 3650
  '';
in

{

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
    };
  };

  services.nginx.virtualHosts.${config.my.nextcloudDomain} = {
    sslCertificate = "${localCert}/cert.pem";
    sslCertificateKey = "${localCert}/key.pem";
    forceSSL = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}