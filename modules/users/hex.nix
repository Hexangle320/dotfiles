{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = "hex";
  description = "Hexangle320";
in {
  imports = [inputs.hjem.nixosModules.default];

  users.users.${username} = {
    inherit description;

    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "minecraft" "copyparty" ];

    hashedPassword = "$y$j9T$oM/XO1OYCEWnEWqqReRS10$MyBVZ2jKKJx0Lu8cIyIQJmCJGCIR.YHr55ogbQbYkI0";

    # only declare common packages here
    # others: hosts/<hostname>/user-configuration.nix
    # if you declare something here that isn't common to literally every host I
    # will personally show up under your bed whoever and wherever you are
    packages = [
      pkgs.btop
      pkgs.firefox
    ];
  };

  programs.git.config = {
    init.defaultBranch = "main";
    user.name = "Hexangle320";
    user.email = "116458789+Hexangle320@users.noreply.github.com";
    core.editor = "code --wait";
  };

  system.userActivationScripts.linktosharedfolder.text = ''
    if [[ ! -h "$HOME/.config/quickshell" ]]; then
      ln -s "$HOME/dotfiles/dots/quickshell/" "$HOME/.config/quickshell"
    fi
  '';

  hjem.users.${username} = {
    enable = true;
    user = username;
    directory = config.users.users.${username}.home;
    clobberFiles = lib.mkForce true;
    files = {
      # Kitty
      ".config/kitty/kitty.conf".source = ../../dots/kitty/kitty.conf;
      # Uwsm
      ".config/uwsm/env".source = ../../dots/uwsm/env;
      # Hyprland
      ".config/hypr/hyprland.conf".source = ../../dots/hypr/hyprland.conf;
      # Hypridle
      ".config/hypr/hypridle.conf".source = ../../dots/hypr/hypridle.conf;
      # Niri
      ".config/niri/config.kdl".source = ../../dots/niri/config.kdl;
      # Quickshell
      # ".config/quickshell".source = ../../dots/quickshell;
      # Fastfetch
      ".config/fastfetch/config.jsonc".source = ../../dots/fastfetch/config.jsonc;
      # Fish
      ".config/fish/config.fish".source = ../../dots/fish/config.fish;
      # Qt6ct
      ".config/qt6ct/qt6ct.conf".source = ../../dots/qt6ct/qt6ct.conf;
      ".config/qt6ct/colors/darker.conf".source = ../../dots/qt6ct/colors/darker.conf;
      # Gtk
      ".config/gtk-4.0/settings.ini".source = ../../dots/gtk4/settings.ini;
      # Git
      ".config/git/.gitconfig".source = ../../dots/git/.gitconfig;
    };
  };
}
