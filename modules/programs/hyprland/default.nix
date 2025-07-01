{ config, pkgs, ... }:

{
  services.gnome.gnome-keyring.enable = true;

  programs.uwsm.enable = true;

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.loginShellInit = ''
  if uwsm check may-start && uwsm select; then
	  exec systemd-cat -t uwsm_start uwsm start default
  fi
  '';
  
  qt.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    kitty
    wofi
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    xwayland
  ];
}
