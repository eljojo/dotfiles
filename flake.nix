{
  description = "jojo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # Home-manager module that can be imported by other flakes
    homeManagerModules = {
      default = self.homeManagerModules.shared;
      shared = import ./nix/home-shared.nix;
    };

    # For convenience, also expose as homeModule (singular)
    homeModule = self.homeManagerModules.shared;
  };
}
