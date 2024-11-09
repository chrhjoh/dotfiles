{
  description = "Chrhjoh's nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util"; # All mac-app-util because of spotlight searching (https://github.com/nix-community/home-manager/issues/1341)
    wezterm.url = "github:wez/wezterm/main?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      mac-app-util,
      darwin,
      wezterm,
      ...
    }:
    {

      darwinConfigurations = {
        SUN1024270 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./configurations/darwin/configuration.nix
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.hcq343 = import ./home/home.nix;
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
              home-manager.extraSpecialArgs = {
                inherit wezterm;
              };

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };
    };
}
