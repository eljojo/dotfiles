{
  description = "jojo's vim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    # Home-manager module that can be imported by other flakes
    homeManagerModules = {
      default = self.homeManagerModules.vim;
      vim = import ./module.nix;
    };

    # Convenience alias (matches dotfiles pattern)
    homeModule = self.homeManagerModules.vim;
  };
}
