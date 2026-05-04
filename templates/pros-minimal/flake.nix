{
  description = "Minimal PROS Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit system;
        });
  in {
    devShells = forEachSupportedSystem ({
      pkgs,
      system,
    }: {
      default = let
        pros-cli = pkgs.python3Packages.buildPythonApplication {
          pname = "pros-cli";
          version = "3.5.6";
          pyproject = true;

          src = pkgs.fetchFromGitHub {
            owner = "purduesigbots";
            repo = "pros-cli";
            tag = "3.5.6";
            hash = "sha256-FuqXQk3hnOFipOZZWiLIk9q4P33N+I87NBBf2N+6OOA=";
          };

          build-system = [pkgs.python3Packages.setuptools];

          pythonRelaxDeps = true;
          pythonRemoveDeps = ["scan-build" "observable"];

          dependencies = with pkgs.python3Packages; [
            wheel
            jsonpickle
            pyserial
            tabulate
            cobs
            click
            rich-click
            cachetools
            requests-futures
            semantic-version
            colorama
            pyzmq
            sentry-sdk
            pypng
            pyinstaller
            pkgs.gcc-arm-embedded
          ];

          doCheck = false;

          meta = {
            mainProgram = "pros";
          };
        };
      in
        pkgs.mkShell {
          packages = [pros-cli pkgs.gcc-arm-embedded];
        };
    });
  };
}
