{ pkgs, ... }:

{
  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "server";
        "netbios name" = "server";
        "security" = "user";
        "guest account" = "nobody";
      };
      data = {
        "comment" = "SMB Data Share";
        "path" = "/srv/smb-share";
        "browseable" = "yes";
        "read only" = "no";
        "create mask" = "0755";
        "directory mask" = "0755";
        "valid users" = "chris";
        "force user" = "chris";
        "force group" = "users";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/smb-share 0755 chris users - -"
  ];

  environment.systemPackages = with pkgs; [
    samba
  ];
}
