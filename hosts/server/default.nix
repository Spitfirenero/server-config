{ ... }:

let
  sharedOptions = import ../../modules/options.nix;
  hostSettings = import ./settings.nix;
in

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix

    sharedOptions.module
    ../../modules/base.nix
    ../../modules/users.nix
    ../../modules/ssh.nix
    ../../modules/firewall.nix
    ../../modules/packages.nix
    ../../modules/scripts.nix
    ../../modules/fail2ban.nix
    ../../modules/tailscale.nix
    ../../modules/samba.nix
    ../../modules/sops.nix
    ../../modules/nextcloud.nix
  ];

  my = {
    nixosVersion = hostSettings.nixosVersion;
    ssh.port = hostSettings.sshPort;
    timeZone = hostSettings.timeZone;
    locale = hostSettings.locale;
    consoleKeyMap = hostSettings.consoleKeyMap;
    domain = hostSettings.domain;
    nextcloudDomain = hostSettings.nextcloudDomain;
    acmeEmail = hostSettings.acmeEmail;
    boot.systemdBoot.enable = hostSettings.bootLoader.systemdBootEnable;
    boot.efi.canTouchEfiVariables = hostSettings.bootLoader.efiCanTouchEfiVariables;
    boot.efi.sysMountPoint = hostSettings.bootLoader.efiSysMountPoint;
  };
}