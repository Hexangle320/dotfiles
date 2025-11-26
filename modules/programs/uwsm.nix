{pkgs, ...}: {
  programs.uwsm.enable = true;

  environment.loginShellInit = ''
    if uwsm check may-start && uwsm select; then
     exec systemd-cat -t uwsm_start uwsm start default
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
