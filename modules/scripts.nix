{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeScriptBin "build" ''
      #!/usr/bin/env bash
      set -euo pipefail
      cd /etc/nixos
      sudo git pull
      sudo nixos-rebuild switch --flake /etc/nixos#nixos --option warn-dirty false
    '')
    (writeScriptBin "clean" ''
      #!/usr/bin/env bash
      set -euo pipefail
      sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
      sudo /run/current-system/bin/switch-to-configuration boot
      sudo nix-collect-garbage -d
      sudo nix-store --optimise
    '')
  ];
}
