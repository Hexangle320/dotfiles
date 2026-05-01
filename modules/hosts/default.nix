{
  inputs,
  outputs,
  nixpkgs,
  ...
}: let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
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
      {
        environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
      }
      inputs.nixos-hardware.nixosModules.omen-14-fb0798ng
      inputs.spicetify-nix.nixosModules.spicetify
      ./Transcend/configuration.nix
      ../../modules
    ];
  };
  Surface = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs outputs system;
      host = {
        hostName = "Surface";
      };
    };
    modules = [
      {
        environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
      }
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
      inputs.impermanence.nixosModules.impermanence
      inputs.spicetify-nix.nixosModules.spicetify
      ./Surface/configuration.nix
      ../../modules
    ];
  };
  Server = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {
      inherit inputs outputs system;
      host = {
        hostName = "Server";
      };
    };
    modules = [
      ./Server/configuration.nix
      inputs.nix-minecraft.nixosModules.minecraft-servers
      inputs.copyparty.nixosModules.default
      {
        nixpkgs.overlays = [ inputs.nix-minecraft.overlay inputs.copyparty.overlays.default ];
      }
    ];
  };
}
