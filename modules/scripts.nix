{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeScriptBin "build" ''
      #!/bin/sh
      cd /etc/nixos
      sudo git pull
      sudo nixos-rebuild switch --flake /etc/nixos#nixos --option warn-dirty false
    '')
  ];
}
