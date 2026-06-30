{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.samba;
in
{
  services.samba = {
    enable = true;
    package = pkgs.samba;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "server";
        "netbios name" = "server";
        "security" = "user";
        "map to guest" = "Never";
        "guest account" = "nobody";
      };
      private = {
        "path" = "/srv/samba/private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "chris";
        "write list" = "chris";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "chris";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d /srv/samba 0775 chris users - -"
    "d /srv/samba/private 0775 chris users - -"
  ];
}
