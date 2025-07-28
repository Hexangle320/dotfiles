{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nix Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Spicetify-nix
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    spicetify-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs outputs nixpkgs;
      }
    );
  };
}