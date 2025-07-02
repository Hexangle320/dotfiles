{pkgs, inputs, lib, ...}:
  let
    system = "x86_64-linux";
    pkgs = import (builtins.fetchGit {
         name = "spotify-1.2.22";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixpkgs-unstable";
         rev = "459104f841356362bfb9ce1c788c1d42846b2454";
     }) {
      inherit system;
      # for some what ever f*ucking reason "nixpkgs.config.allowUnfree = true;"
      # doesn't work
      config = { allowUnfree = true; };
     };

    oldSpotify = pkgs.spotify;
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in
  {
  programs.spicetify = {
    enable = true;
    spotifyPackage = oldSpotify;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      lyricsPlus
    ];
    enabledSnippets = with spicePkgs.snippets; [
    hideMadeForYou
    hideRecentlyPlayed
    hideWhatsNewButton
    removePopular
    removeRecentlyPlayed
    removeTheArtistsAndCreditsSectionsFromTheSidebar
    disableRecommendations
    ];
    
    theme = {
      name = "text";

      src = "${pkgs.fetchFromGitHub {
        owner = "spicetify";
        repo = "spicetify-themes";
        rev = "c6e82dfeaa46ee9060d0c02fc437989eb77f6c61"; 
        hash = "sha256-kpHIWHuubTEwIoi+645Ai/PqXTlZMhRcBueYwgCqG2E=";
      }}/text";
  
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = false;
      overwriteAssets = true;
      additonalCss = "";
    };
    
    colorScheme = "RosePineMoon";

    # theme = spicePkgs.themes.matte;
    
    # colorScheme = "rose-pine-moon";


    };
   }