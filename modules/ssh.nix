{ config, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ config.my.ssh.port ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      ChallengeResponseAuthentication = false;
      PubkeyAuthentication = true;
      UsePAM = true;
      X11Forwarding = false;
      AllowUsers = [ "chris" ];
    };
    openFirewall = false;
  };
}
