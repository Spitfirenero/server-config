{
  module = { lib, ... }:
    {
      options.my.ssh.port = lib.mkOption {
        type = lib.types.port;
        description = "Port Definition for SSH and Firewall";
      };

      options.my.nixosVersion = lib.mkOption {
        type = lib.types.str;
        description = "NixOS release version used by the flake and stateVersion for this host.";
      };

      options.my.timeZone = lib.mkOption {
        type = lib.types.str;
        description = "System timezone for the host.";
      };

      options.my.locale = lib.mkOption {
        type = lib.types.str;
        description = "Primary locale for the host.";
      };

      options.my.consoleKeyMap = lib.mkOption {
        type = lib.types.str;
        description = "Console keyboard layout for the host.";
      };

      options.my.boot.systemdBoot.enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable systemd-boot for the host.";
      };

      options.my.boot.efi.canTouchEfiVariables = lib.mkOption {
        type = lib.types.bool;
        description = "Allow NixOS to modify EFI boot variables.";
      };

      options.my.boot.efi.sysMountPoint = lib.mkOption {
        type = lib.types.str;
        description = "Mount point for the EFI system partition.";
      };
    };
}
