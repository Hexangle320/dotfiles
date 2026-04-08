{
  pkgs,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
  };
  environment.systemPackages = with pkgs; [
    lazygit
  ];
}
