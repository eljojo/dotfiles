{
  description = "jojo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    {
      # nix-darwin configuration for macOS
      darwinConfigurations."jojo-m1" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self; };
        modules = [
          ./nix/darwin-configuration.nix
          home-manager.darwinModules.home-manager
        ];
      };

      darwinConfigurations."jojo-m2" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self; };
        modules = [
          home-manager.darwinModules.home-manager
          ./nix/darwin-configuration.nix
        ];
      };

      # Home-manager module that can be imported by other flakes
      homeManagerModules = {
        default = self.homeManagerModules.shared;
        shared = import ./nix/home-shared.nix;
        vim = import ./vim/module.nix;
      };

      # For convenience, also expose as homeModule (singular)
      homeModule = self.homeManagerModules.shared;
    };
}
