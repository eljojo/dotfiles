{
  description = "Jojo's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs: 
  let

  in {
    darwinConfigurations."jojo-m2" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      inputs = { inherit darwin nixpkgs home-manager; };
      modules = [
        ./darwin-configuration.nix

        home-manager.darwinModule
          {
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
      ];
    };
  };
}
