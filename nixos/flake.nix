{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nix Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Spicetify-nix
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    # Hyprland 
    hyprland.url = "github:hyprwm/Hyprland";
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
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.omen-14-fb0798ng
          spicetify-nix.nixosModules.spicetify
        ];
      };
    };
  };
}
