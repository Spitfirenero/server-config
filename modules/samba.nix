{ pkgs, ... }:

{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      workstation = true;
    };
  };

  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "server";
        "netbios name" = "server";
        "security" = "user";
        "guest account" = "nobody";
        "map to guest" = "Never";
        "mdns name" = "mdns";
      };
      data = {
        "comment" = "SMB Data Share";
        "path" = "/srv/smb-share";
        "browseable" = "yes";
        "guest ok" = "no";
        "public" = "no";
        "read only" = "no";
        "create mask" = "0755";
        "directory mask" = "0755";
        "valid users" = "chris";
        "force user" = "chris";
        "force group" = "users";
      };
    };
  };

  environment.etc."avahi/services/smb.service".text = ''
    <?xml version="1.0" standalone='no'?>
    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    <service-group>
      <name replace-wildcards="yes">%h</name>
      <service>
        <type>_smb._tcp</type>
        <port>445</port>
      </service>
      <service>
        <type>_device-info._tcp</type>
        <port>0</port>
        <txt-record>model=TimeCapsule8,119</txt-record>
      </service>
    </service-group>
  '';

  systemd.tmpfiles.rules = [
    "d /srv/smb-share 0755 chris users - -"
  ];

  environment.systemPackages = with pkgs; [
    samba
  ];
}
