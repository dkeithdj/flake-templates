{
  description = "A Python project using uv and flake-parts";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { pkgs, system, ... }:
        {
          devShells.default = pkgs.mkShell {
            name = "python-uv-simple";

            packages = with pkgs; [
              python313 # or whichever version you use
              uv # fast dependency resolver & installer
            ];

            shellHook = ''
              echo "Welcome to the Python + uv dev shell!"
              echo "Running: uv venv && uv sync"
              if [ ! -d .venv ]; then
                uv venv
              fi
              uv sync --all-extras
              export PATH="$PWD/.venv/bin:$PATH"
            '';
          };
        };
    };
}
