{
  description = "A Python project using uv and flake-parts";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { pkgs, system, ... }:
        let
          inherit (nixpkgs) lib;
        in
        {
          devShells.default = pkgs.mkShell {
            name = "python-uv-simple";

            packages = with pkgs; [
              python313 # or whichever version you use
              uv # fast dependency resolver & installer
              gcc
              zlib

            ];
            env =
              {
                # UV_PYTHON_DOWNLOADS = "never";
                # UV_PYTHON = python.interpreter;
                VIRTUAL_ENV = ".venv";
              }
              // lib.optionalAttrs pkgs.stdenv.isLinux {
                # Python libraries often load native shared objects using dlopen(3).
                # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
                LD_LIBRARY_PATH = lib.makeLibraryPath [
                  pkgs.pythonManylinuxPackages.manylinux1
                  pkgs.stdenv.cc.cc
                  pkgs.zstd
                  pkgs.zlib
                ];
                PATH = "$PWD/.venv/bin:$PATH";
              };
            shellHook = ''
              echo "Welcome to the Python + uv dev shell!"
              echo "Running: uv venv && uv sync"
              if [ ! -d $VIRTUAL_ENV ]; then
                uv venv
              fi
              uv sync --all-extras
              export PATH="$PWD/.venv/bin:$PATH"
            '';
          };
        };
    };
}
