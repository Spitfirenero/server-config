{ ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "public" = {
        "path" = "/srv/Shares/Public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "chris";
        "force group" = "users";
      };
      "private" = {
        "path" = "/srv/Shares/Private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "chris";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "chris";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 139 445 5357 ];
    allowedUDPPorts = [ 137 138 3702 ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/Shares 0755 chris users - -"
    "d /srv/Shares/Public 0755 chris users - -"
    "d /srv/Shares/Private 0750 chris users - -"
  ];
}
