{
  description = "jojo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Code CLI - pre-built binaries from official Anthropic releases
    nix-claude-code = {
      url = "github:ryoppippi/nix-claude-code";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
            inherit inputs self hostName;

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

      # Systems we expose checks for (the Mac + the lisa NixOS hosts).
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ];
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

      # NixOS module: jojo's configured neovim installed system-wide (root + all
      # users), no home-manager. Import on a host: imports = [ self.nixosModules.neovim ];
      nixosModules.neovim = import ./vim/nixos.nix;

      # `nix flake check` builds each configured neovim and asserts its invariants
      # (colorscheme/treesitter/keymaps; slim has no copilot/node). See vim/checks.nix.
      checks = forAllSystems (
        system:
        import ./vim/checks.nix {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        }
      );
    };
}
