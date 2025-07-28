{pkgs, ...}: {
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    plymouth.enable = true;
    plymouth.theme = "fade-in";

    kernelPackages = pkgs.linuxPackages_latest;

    loader.timeout = 5;
  };
}
