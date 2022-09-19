{
  description = "Jojo's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }: {
    darwinConfigurations."jojo-m2" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./darwin-configuration.nix ];
    };
  };
}
