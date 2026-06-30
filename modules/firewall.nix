{ config, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ config.my.ssh.port 445 139 ];
    allowedUDPPorts = [ 137 138 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}
