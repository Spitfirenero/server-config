{ config, ... }:

{
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [
          "192.168.0.200"
          "127.0.0.1"
          "::1"
        ];
        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
          "192.168.0.0/24 allow"
        ];
        local-zone = [
          "themoser.net. static"
        ];
        local-data = [
          ''"themoser.net. IN A 192.168.0.200"''
          ''"cloud.themoser.net. IN A 192.168.0.200"''
          ''"office.themoser.net. IN A 192.168.0.200"''
        ];
      };

      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1"
            "9.9.9.9"
          ];
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}