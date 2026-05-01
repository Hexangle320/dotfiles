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
    ../../../modules/services/fail2ban.nix
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
      extraGroups = ["networkmanager" "wheel" "minecraft"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNxrsfCUUiGpccHJ5ZfOdFSPOiUXTMd2uj3A2GTVYLu hex@server 116458789+Hexangle320@users.noreply.github.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMbeRDlstuEGCOaz9TCln1GaPTJAzzi9YhonXvsH8yI 116458789+Hexangle320@users.noreply.github.com"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    openssl
    caddy
  ];

  programs.nix-ld.enable = true; # for vscode remote

  services.kasmweb.enable = true;
  services.kasmweb.listenPort = 8443;

  environment.defaultPackages = lib.mkForce [];

  # Generate self-signed cert for the public IP
  security.acme.acceptTerms = false; # not using ACME

  services.anubis = {
    instances = {
      main = {
        enable = true;
        settings = {
          TARGET = "http://127.0.0.1:8088";
          COOKIE_DOMAIN = "";
          OG_PASSTHROUGH = true;
          BIND_NETWORK = "tcp";
          BIND = "127.0.0.1:8089";
        };
      };
    };
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';
    extraConfig = ''
      (anubis_proxy) {
        reverse_proxy localhost:8089 {
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
          header_up X-Forwarded-Host {host}
          header_up X-Forwarded-Port "443"
        }
      }

      :443 {
        tls /var/lib/caddy-certs/cert.pem /var/lib/caddy-certs/key.pem

        handle /.within.website/* {
          import anubis_proxy
        }
        handle /glance/* {
          import anubis_proxy
        }
        handle /2fauth/* {
          import anubis_proxy

        reverse_proxy https://localhost:8443 {
          transport http {
            tls_insecure_skip_verify
            keepalive 30s
          }
          header_up Host {host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
          header_up X-Forwarded-Host {host}
          header_up X-Forwarded-Port "443"
          header_up Connection "Upgrade"
          header_up Upgrade "websocket"
          flush_interval -1
        }
      }

      :8088 {
        bind 127.0.0.1

        handle /2fauth/* {
          uri strip_prefix /2fauth
          reverse_proxy localhost:8000
        }

        handle /glance/* {
          uri strip_prefix /glance
          reverse_proxy localhost:8080
        }
        }
      }
    '';
  };

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
    22 # SSH
    80 # HTTP
    443 # HTTPS
    8443 # Kasm
    8100 # Termix
  ];

  # Disable documentation for minimal install.
  documentation.enable = false;

  system.stateVersion = "25.05";
}
