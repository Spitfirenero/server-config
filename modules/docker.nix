{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  users.users.chris.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
