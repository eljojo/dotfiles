{
  description = "jojo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
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
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      # nix-darwin configuration for macOS
      mkMac =
        hostName:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
            inherit self;

            unstable = import nixpkgs-unstable {
              system = "aarch64-darwin";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./nix/darwin-configuration.nix
            home-manager.darwinModules.home-manager
          ];
        };
    in
    {
      # nix-darwin configuration for macOS
      darwinConfigurations."jojo-m1" = mkMac "jojo-m1";
      darwinConfigurations."jojo-m2" = mkMac "jojo-m2";
      darwinConfigurations."jojo-m4-mini" = mkMac "jojo-m4-mini";

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
