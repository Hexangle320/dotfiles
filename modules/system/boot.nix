{
  lib,
  pkgs,
  ...
}: {
  boot = {
    loader.systemd-boot.enable = true;
    initrd.systemd.enable = true;
    loader.efi.canTouchEfiVariables = true;

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "intremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    plymouth.enable = true;
    plymouth.theme = "fade-in";

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    loader.timeout = 5;
  };
}
