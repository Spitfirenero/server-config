{ config, ... }:

{
  system.stateVersion = config.my.nixosVersion;
  time.timeZone = config.my.timeZone;

  i18n.defaultLocale = config.my.locale;

  console.keyMap = config.my.consoleKeyMap;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };
}
