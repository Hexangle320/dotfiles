{pkgs, ...}: {
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig."99-disable-suspend" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            # Uncomment to disable suspend for all sinks
            # {
            #   "node.name" = "~alsa_input.*";
            # }
            # {
            #   "node.name" = "~alsa_output.*";
            # }
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Headphones__sink";
            }
          ];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
              "node.always-process" = true;
              "dither.method" = "wannamaker3";
              "dither.noise" = 1;
            };
          };
        }
      ];
    };
  };
}
