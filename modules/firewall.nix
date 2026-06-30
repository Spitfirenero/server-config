{ config, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ config.my.ssh.port 445 139 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}
