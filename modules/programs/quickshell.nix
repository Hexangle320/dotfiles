{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.quickshell.packages.${system}.default
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    brightnessctl
  ];
}
