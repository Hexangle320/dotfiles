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
    # NixOS configuration entrypoint
    nixosConfigurations = {
      Transcend = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./modules
          ./hosts/Transcend/configuration.nix
          nixos-hardware.nixosModules.omen-14-fb0798ng
          spicetify-nix.nixosModules.spicetify
        ];
      };
    };
  };
}
