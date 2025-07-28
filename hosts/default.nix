{ inputs, outputs, nixpkgs, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

in
{
  # Laptop Profile
  Transcend = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs outputs system;
      host = {
        hostName = "Transcend";
      };
    };
    modules = [
      inputs.nixos-hardware.nixosModules.omen-14-fb0798ng
      inputs.spicetify-nix.nixosModules.spicetify
      ./Transcend/configuration.nix
      ../modules
    ];
  };
}