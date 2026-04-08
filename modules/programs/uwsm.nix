{pkgs, ...}: {
  programs.uwsm.enable = true;

  environment.loginShellInit = ''
    if uwsm check may-start; then
     exec uwsm start niri-uwsm.desktop
    fi
  '';

  programs.uwsm.waylandCompositors = {
    niri = {
      prettyName = "Niri";
      comment = "A scrollable-tiling Wayland compositor.";
      binPath = "${pkgs.niri}/bin/niri-session";
    };
  };
}
