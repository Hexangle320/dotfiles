{
  config,
  inputs,
  ...
}: {
  imports = [inputs.aagl.nixosModules.default];
  nix.settings.extra-substituters = ["https://ezkea.cachix.org"];
  nix.settings.extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  programs = {
    anime-game-launcher.enable = true;
    # anime-games-launcher.enable = true;
    # honkers-railway-launcher.enable = true;
    # honkers-launcher.enable = true;
    # wavey-launcher.enable = true;
    # sleepy-launcher.enable = true;
  };
}
