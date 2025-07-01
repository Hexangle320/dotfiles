{pkgs, ...}: {
  imports = [
    ./hyprland
    ./quickshell
  ];

  # global
  environment.systemPackages = [
    pkgs.git
    pkgs.p7zip
    pkgs.unrar
    pkgs.kitty
    pkgs.vscode

    ## Control Software 
    pkgs.pavucontrol
    pkgs.mission-center
    pkgs.better-control
    pkgs.pciutils
    pkgs.xfce.thunar
  ];

  environment.variables.EDITOR = "vscode";
  environment.variables.MANPAGER = "vscode";
  # remove nano
  programs.nano.enable = false;

  # wayland on electron and chromium based apps
  # disable if slow startup time for the same
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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