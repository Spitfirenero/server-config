{ ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "server";
        "netbios name" = "server";
        "security" = "user";
        "map to guest" = "never";
      };
      "data" = {
        "path" = "/srv/samba/data";
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

  systemd.tmpfiles.rules = [
    "d /srv/samba 0755 chris users - -"
    "d /srv/samba/data 0755 chris users - -"
  ];
}
