# NixOS module: install jojo's configured neovim system-wide (root + all users),
# with NO home-manager. Import it into a host's configuration:
#
#   imports = [ inputs.dotfiles.nixosModules.neovim ];
#
# It provides the `nvim` command with the lightweight (slim) config: same editor
# experience as the Mac (treesitter, solarized dark, fzf-lua, etc.) but WITHOUT ruby,
# copilot, or node — a ~390 MB smaller closure. It does NOT set $EDITOR or alias
# vim/vi — do that yourself if you want it as the default editor.
#
# The host still needs `nixpkgs.config.allowUnfree = true;` — several of these vim
# plugins (delimitMate, etc.) carry nixpkgs' "unfree" placeholder license; it's a
# metadata quirk, not actually proprietary software.
{
  pkgs,
  lib,
  ...
}:
let
  nvim = import ./neovim.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = [ nvim.slimPackage ];
}
