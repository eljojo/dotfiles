# NixOS module: install jojo's configured neovim system-wide (root + all users),
# with NO home-manager. Import it into a host's configuration:
#
#   imports = [ inputs.dotfiles.nixosModules.neovim ];
#
# It provides the `nvim` command with the lightweight (slim) config: "a step up above
# vanilla" for quick root edits — your shortcuts + NERDTree, fzf.vim for <C-p>, and
# treesitter + solarized for the file types root touches (nix/bash/yaml/lua/json/md).
# No fzf-lua / copilot / node / dev-language plugins. ~135 MB closure, and all-free —
# the host does NOT need allowUnfree. It does NOT set $EDITOR or alias vim/vi; do that
# yourself if you want it as the default editor.
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
