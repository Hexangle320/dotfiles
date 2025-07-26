{pkgs, ...}: {
  imports = [
    ./hyprland
    ./quickshell
    ./spotify
    ./discord
    ./zsh
  ];

  # global
  environment.systemPackages = [
    pkgs.git
    pkgs.p7zip
    pkgs.unrar
    pkgs.kitty
    pkgs.vscode
    pkgs.udiskie
    pkgs.fastfetch

    ## Theming Software
    pkgs.hyprcursor
    pkgs.waypaper
    pkgs.nwg-look

    # Wallpaper backend
    pkgs.swww

    ## Control Software 
    pkgs.pavucontrol
    pkgs.mission-center
    pkgs.better-control
    pkgs.xfce.thunar
  ];

  # add for drive mounting and trash
  services.gvfs.enable = true;

  environment.variables.EDITOR = "code";
  environment.variables.MANPAGER = "nano";
  
  programs.nano.enable = true;

  # wayland on electron and chromium based apps
  # disable if slow startup time for the same
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # wayland on firefox
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # firefox smooth scroll
  environment.sessionVariables.MOZ_USE_XINPUT2 = "1";

  security.sudo = {
    execWheelOnly = true;
    extraRules = [
      {
        users = ["***REMOVED***"];
        # lets me rebuild without having to enter the password
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];
  };
}