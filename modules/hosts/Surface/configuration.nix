{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../users/hex.nix
    ../../services/tailscale.nix
    ../../services/openssh.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.thermald.enable = true;

  hardware.microsoft-surface.kernelVersion = "stable";
  services.iptsd.enable = true;

  powerManagement.enable = true;
  powerManagement.cpufreq.max = 2000000;
  powerManagement.cpufreq.min = 1000000;
  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "Surface";
  networking.networkmanager.enable = true;

  services.udev.extraRules = ''
    # allow user rw access to serial ports
    KERNEL=="ttyACM[0-9]*",MODE="0666"
  '';

  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
      "/var/db/sudo"
      "/var/lib/nixos"
      "/etc/thermald"
      "/var/lib/tailscale"
    ];

    files = [
      "/etc/machine-id"

      # Required for SSH. If you have keys with different algorithms, then
      # you must also persist them here.
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      # if you use docker or LXD, also persist their directories
    ];
  };

  boot.initrd.systemd = {
    enable = true; # this enabled systemd support in stage1 - required for the below setup
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = ["initrd.target"];

      # Double back slash as forward slash exits
      after = ["dev-disk-by\\x2duuid-174d37e0\\x2de038\\x2d4a35\\x2d9093\\x2d1b00e701ae9d.device"];
      requires = ["dev-disk-by\\x2duuid-174d37e0\\x2de038\\x2d4a35\\x2d9093\\x2d1b00e701ae9d.device"];

      # Before mounting the system root (/sysroot) during the early boot process
      before = ["sysroot.mount"];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the BTRFS root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -t btrfs -o subvol=/ /dev/disk/by-uuid/174d37e0-e038-4a35-9093-1b00e701ae9d /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines

        btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root
        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };

  services.tailscale = {
    enable = true;
  };

  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    iptsd
  ];
  system.stateVersion = "25.05";
}
