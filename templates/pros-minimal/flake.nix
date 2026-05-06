{
  description = "Minimal PROS Flake";
  # fix for "In included file: 'gnu/stubs-32.h' file not found" - https://discourse.nixos.org/t/dev-shell-flake-clangd-cant-find-gnu-stubs-32-h/51067
  # based off of https://github.com/BattleCh1cken/pros-cli-nix/tree/master and https://github.com/VEXU-GHOST/vexu_tank
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
      lib ? nixpkgs.lib,
    }: {
      default = let
        scan-build = pkgs.python3Packages.buildPythonApplication rec {
          pname = "scan-build";
          version = "2.0.20";
          pyproject = true;
          build-system = [pkgs.python3Packages.setuptools];

          src = pkgs.fetchPypi {
            inherit pname version;
            hash = "sha256-8fnx3D2vkG7xBgd9usTYcvV0CEMXPcdAcO87Odo9Dwc=";
          };

          docheck = false;
        };

        observable = pkgs.python3Packages.buildPythonApplication rec {
          pname = "observable";
          version = "1.0.3";
          pyproject = true;
          build-system = [pkgs.python3Packages.setuptools];

          src = pkgs.fetchPypi {
            inherit pname version;
            hash = "sha256-l/6OnYwqYYXO42YfpfupzjjHujiIlBMpQM1qgWM2Jtk=";
          };

          propagatedBuildInputs = [
            pkgs.python3Packages.pytest
          ];

          docheck = false;
        };

        click = pkgs.python3Packages.click.overridePythonAttrs (old: rec {
          version = "8.1.8";
          src = pkgs.fetchPypi {
            pname = "click";
            inherit version;
            hash = "sha256-7VPJ2JkNg8Kifermjk7jN0c/YzDAQKMdQiXJV00WCWo=";
          };

          patches = [];
          disabledTests = [];
        });

        rich-click = pkgs.python3Packages.rich-click.overridePythonAttrs (old: rec {
          version = "1.7.4";
          src = pkgs.fetchPypi {
            pname = "rich-click";
            inherit version;
            hash = "sha256-fOXejk3AMzrslGETUps+6zSfLl0vr+6Wue347jagE5U=";
          };

          patches = [];
          disabledTests = [];
          disabledTestPaths = [];

          dependencies = [
            click
            pkgs.python3Packages.rich
            pkgs.python3Packages.typing-extensions
          ];
          propagatedBuildInputs = [];
        });

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

          postPatch = ''
            substituteInPlace requirements.txt \
              --replace 'scan-build==2.0.13' 'scan-build' \
              --replace 'pyinstaller' ' ' \
              --replace 'pypng==0.0.20' 'pypng' \
          '';

          propagatedBuildInputs = with pkgs.python3Packages; [
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
            requests
            scan-build
            observable
            setuptools
          ];

          doCheck = false;

          meta = {
            mainProgram = "pros";
          };
        };
      in
        pkgs.mkShell {
          packages = [
            pros-cli
            pkgs.gcc-arm-embedded
            pkgs.clang-tools
            pkgs.bear
            pkgs.python311
          ];
          shellHook = ''
            export PATH=${pkgs.gcc-arm-embedded}/bin:$PATH
            export MAKEFLAGS="-j $((`nproc` - 1))"
            export PYTHONWARNINGS="ignore::UserWarning:pros.common.utils" # hides warning when using pros
          '';
        };
    });
  };
}
