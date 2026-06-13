# NixOS module: install jojo's configured neovim system-wide (root + all users),
# with NO home-manager. Import it into a host's configuration:
#
#   imports = [ inputs.dotfiles.nixosModules.neovim ];
#
# It provides the `nvim` command with the same plugins/config as the Mac terminal
# nvim (treesitter, solarized dark, fzf-lua, etc.). It does NOT set $EDITOR or alias
# vim/vi — do that yourself if you want it as the default editor.
#
# Note: the config includes vim-ruby, which nixpkgs marks unfree, so the host needs
#   nixpkgs.config.allowUnfree = true;
# (or an allowUnfreePredicate permitting "vim-ruby").
{
  pkgs,
  lib,
  ...
}:
let
  nvim = import ./neovim.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = [ nvim.package ];
}
