{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nix Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Spicetify-nix
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    # Alejandra
    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    # Quickshell
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    # Hjem
    hjem.url = "github:feel-co/hjem";
    hjem.inputs.nixpkgs.follows = "nixpkgs";
    # aagl
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    spicetify-nix,
    alejandra,
    quickshell,
    hjem,
    aagl,
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
