{ config, ... }:

{
  networking.hostName = "server";

  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  networking.interfaces.enp0s31f6 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.0.200";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  networking.hosts."192.168.0.200" = [ config.my.nextcloudDomain ];
}