{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeScriptBin "build" ''
      #!/bin/sh
      sudo nixos-rebuild switch --flake /etc/nixos#nixos --option warn-dirty false
    '')
  ];
}
