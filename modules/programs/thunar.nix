{
  config,
  pkgs,
  ...
}: {
  programs.thunar.enable = true;
  programs.xfconf.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    file-roller
  ];
}
