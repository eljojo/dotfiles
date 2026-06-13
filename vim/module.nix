# Home-manager module for vim/neovim on the Mac.
# Plugin sets + config live in ./neovim.nix, shared with the NixOS module (./nixos.nix).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  nvim = import ./neovim.nix { inherit pkgs lib; };

  # Pack directory for the shared (classic) plugins — used by MacVim only. Note this
  # uses sharedPlugins, NOT the nvim-only set, so MacVim never gets the Lua plugins.
  packDir = pkgs.vimUtils.packDir {
    home-manager = {
      start = nvim.sharedPlugins;
    };
  };

  # Vimrc that prepends the nix pack dir to packpath so MacVim finds the plugins.
  vimrcFull = pkgs.writeText "vimrc" ''
    " Load plugins from nix pack directory
    set packpath^=~/.vim/nix-pack
    set runtimepath^=~/.vim/nix-pack

    ${nvim.vimrcContent}
  '';
in
{
  # No programs.vim: neovim provides the `vim`/`vi` commands via viAlias/vimAlias, so
  # it's the single terminal editor. MacVim is unaffected — it reads ~/.vimrc +
  # ~/.vim/nix-pack directly (generated below), not this binary.
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # No ruby/python remote-plugin hosts (none of jojo's plugins use them); adopt the
    # 26.05 defaults explicitly to silence the deprecation warning.
    withRuby = false;
    withPython3 = false;

    # copilot.vim needs `node` on PATH (also covers the headless Linux box).
    extraPackages = nvim.extraPackages;

    # NOTE(clipboard-over-ssh): yanking to the *local* machine's clipboard from nvim
    # on the Linux box isn't wired up — xclip/wl-copy don't help over SSH. The fix is
    # an OSC52 clipboard provider (neovim >=0.10 can emit OSC52). Deferred for now.

    plugins = nvim.neovimPlugins;
    extraConfig = nvim.vimrcContent;
    initLua = nvim.initLua;
  };

  # Vimrc + gvimrc for MacVim.
  home.file.".vimrc".source = vimrcFull;
  home.file.".gvimrc".source = ./gvimrc;

  # Nix plugin pack directory (for MacVim).
  home.file.".vim/nix-pack".source = packDir;

  # Colorschemes, syntax, and ftdetect.
  home.file.".vim/colors".source = ./colors;
  home.file.".vim/ftdetect".source = ./ftdetect;
  home.file.".vim/syntax".source = ./syntax;

  # Writable directories for vim state.
  home.activation.createVimDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.vim/undofiles
    mkdir -p $HOME/.vim/backup
  '';
}
