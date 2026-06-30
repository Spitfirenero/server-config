{
  nixosVersion = "24.11";
  sshPort = 2222;
  timeZone = "Australia/Sydney";
  locale = "en_AU.UTF-8";
  consoleKeyMap = "us";
  bootLoader = {
    systemdBootEnable = true;
    efiCanTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };
}