{ ... }:

{
  users.users.chris = {
    isNormalUser = true;
    description = "chris";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGz+Tf5YSmEsRrb+jgp7gGZbQqqedbWe4BaAIRiZdoO home-pc"
    ];
  };
}
