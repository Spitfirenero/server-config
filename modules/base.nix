{ config, ... }:

{
  system.stateVersion = config.my.nixosVersion;
  time.timeZone = config.my.timeZone;

  i18n.defaultLocale = config.my.locale;

  console.keyMap = config.my.consoleKeyMap;

  boot.loader.systemd-boot.enable = config.my.boot.systemdBoot.enable;
  boot.loader.efi.canTouchEfiVariables = config.my.boot.efi.canTouchEfiVariables;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };
}
