{ config, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ config.my.ssh.port ];
  };
}
