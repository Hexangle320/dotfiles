{...}: {
  networking = {
    nftables.enable = true;
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        macAddress = "random";
      };
    };

    firewall = {
      enable = false;
      allowedTCPPortRanges = [];
      allowedUDPPortRanges = [];
    };
  };
}