{
  config,
  pkgs,
  ...
}: {
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    quickshell
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    brightnessctl
  ];
}
