{
  description = "Christian Johansens's nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs
    , darwin
    , home-manager
    , flake-utils
    , ...
    }:
    let
      mkDarwinSystem = { user, host, system }:
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            home-manager.darwinModules.home-manager
            ./configurations/common.nix
            ./configurations/${host}.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = import ./users/${user}.nix;
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        SUN1024270 = mkDarwinSystem {
          system = "aarch64-darwin";
          user = "hcq343";
          host = "SUN1024270";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        name = "dotfiles";
        packages = with pkgs; [
          nixd
          nixpkgs-fmt
          lua-language-server
          stylua
        ];
      };
    });
}
