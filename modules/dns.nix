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
          "themoser.net. A 192.168.0.200"
          "cloud.themoser.net. A 192.168.0.200"
          "office.themoser.net. A 192.168.0.200"
        ];
      };

      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
            "9.9.9.9@853#dns.quad9.net"
          ];
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}