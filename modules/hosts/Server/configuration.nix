{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../../modules/programs/fish.nix
    ../../../modules/programs/nix.nix
    ../../../modules/programs/git.nix
    ../../../modules/programs/direnv.nix
    ../../../modules/users/hex.nix
    ../../../modules/services/minecraft.nix
    ../../../modules/services/openssh.nix
    ../../../modules/services/tailscale.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };

  systemd.targets.multi-user.enable = true;

  networking.hostName = "Server";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;
    users.hex = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNxrsfCUUiGpccHJ5ZfOdFSPOiUXTMd2uj3A2GTVYLu hex@server 116458789+Hexangle320@users.noreply.github.com"];
    };
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = ["hex"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    curl
    wget
    openssl
    caddy
  ];

  #vscode-remote-workaround.enable = true;
  programs.nix-ld.enable = true;
  services.kasmweb.enable = true;
  services.kasmweb.listenPort = 8443;
  environment.defaultPackages = lib.mkForce [];

  # Generate self-signed cert for the public IP
  security.acme.acceptTerms = false; # not using ACME

  # Disable autologin.
  services.getty.autologinUser = null;
  virtualisation.docker.enable = true;
  virtualisation.docker = {
    daemon.settings = {
      iptables = true;
    };
  };

  networking.firewall.enable = lib.mkForce true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22 #SSH
    80 # HTTP
    443 #HTTPS
    8443 #Kasm
    8080 #Kasm
    4444 #Kasm
    8181 #Kasm
    8182 #Kasm
    5432 #Kasm
    5555
    6379 #Kasm
    8100 # Termix
  ];

  # Disable documentation for minimal install.
  documentation.enable = false;

  system.stateVersion = "25.05";
}
