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
        "restrict anonymous" = "2";
      };
      "data" = {
        "path" = "/srv/samba/data";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "chris";
        "write list" = "chris";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force create mode" = "0664";
        "force directory mode" = "0775";
        "force user" = "chris";
        "force group" = "users";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/samba 0775 chris users - -"
    "d /srv/samba/data 0775 chris users - -"
  ];
}
