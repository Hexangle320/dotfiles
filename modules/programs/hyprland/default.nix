{
  config,
  pkgs,
  ...
}: {
  services.gnome.gnome-keyring.enable = true;

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  qt.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    kitty
    wofi
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    cliphist # clipboard history
    mako # notification system developed by swaywm maintainer
    xwayland
    adwaita-icon-theme # a simple icon theme
    adw-gtk3
    hyprpolkitagent
  ];
}
