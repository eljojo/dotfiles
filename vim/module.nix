# Home-manager module for vim/neovim configuration
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Build plugins not in nixpkgs
  # vim-yankstack: currently DISABLED in sharedPlugins below (jojo wasn't using
  # the <M-p>/<M-P> yank-ring cycling); kept here so re-enabling is one uncomment.
  vim-yankstack = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-yankstack";
    version = "2021-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "maxbrunsfeld";
      repo = "vim-yankstack";
      rev = "157a659c1b101c899935d961774fb5c8f0775370";
      sha256 = "sha256-lBMfOxUF6vykuVPmqZ3rsy6ryyprui8+dHpuKepXXp8=";
    };
  };

  ag-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "ag.vim";
    version = "2021-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "rking";
      repo = "ag.vim";
      rev = "4a0dd6e190f446e5a016b44fdaa2feafc582918e";
      sha256 = "sha256-IheUi3ishLP8VxUZHBoGtrm2OCxAVwwSCIP3sXHN57c=";
    };
  };

  # Common plugins for both vim and neovim
  sharedPlugins =
    (with pkgs.vimPlugins; [
      vim-sensible
      vim-ruby
      syntastic
      vim-easymotion
      nerdtree
      vim-markdown
      vim-endwise
      delimitMate
      ag-vim
      vim-rhubarb
      vim-fugitive
      vim-go
      rust-vim
      vim-colors-solarized
      vim-commentary
      vim-surround
      camelcasemotion
      rainbow_parentheses-vim
      # vim-yankstack  # disabled 2026-06-12 — wasn't using the <M-p>/<M-P> yank-ring
      #                # cycling. Uncomment to restore (derivation defined above;
      #                # MacVim also relies on `:set macmeta` in gvimrc, still present).
      vim-javascript
      yats-vim # TypeScript + .tsx syntax
      indentLine
      fzf-wrapper
      fzf-vim
      vim-nix
      copilot-vim
    ])
    # markdown-preview: jojo only uses :MarkdownPreview on the Mac. The Linux box is
    # headless SSH with no browser, so don't ship it there.
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      pkgs.vimPlugins.markdown-preview-nvim
    ];

  # Plugins that load ONLY in terminal neovim (Lua-native; deliberately NOT added to
  # packDir, so MacVim never sees them and stays on the classic vimscript set above).
  neovimOnlyPlugins = with pkgs.vimPlugins; [
    # Treesitter — better highlighting for code (rust/go/ts/tsx/js/nix/ruby/lua/sh).
    # withAllGrammars ships prebuilt parsers from nix (no :TSInstall, no compiler).
    nvim-treesitter.withAllGrammars
  ];

  # Shared vimrc content (stripped of Vundle)
  vimrcContent = builtins.readFile ./vimrc;

  # Neovide-specific lua config
  neovideConfig = builtins.readFile ./init-neovide.lua;

  # Neovim-only Lua layer (plugin setup + nvim-specific tweaks). Loaded after the
  # shared vimrc is sourced, so anything here wins on nvim; MacVim never reads it.
  nvimLuaConfig = builtins.readFile ./init-nvim.lua;

  # Build pack directory for all plugins (used by MacVim)
  packDir = pkgs.vimUtils.packDir {
    home-manager = {
      start = sharedPlugins;
    };
  };

  # Vimrc that sets up packpath for MacVim compatibility
  vimrcFull = pkgs.writeText "vimrc" ''
    " Load plugins from nix pack directory
    set packpath^=~/.vim/nix-pack
    set runtimepath^=~/.vim/nix-pack

    ${vimrcContent}
  '';

in
{
  # No programs.vim: neovim provides the `vim`/`vi` commands via viAlias/vimAlias
  # below, so it's the single terminal editor. MacVim is unaffected — it reads
  # ~/.vimrc + ~/.vim/nix-pack directly (generated further down), not this binary.

  # Configure neovim as the terminal editor (and for Neovide)
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # No ruby/python remote-plugin hosts needed (none of jojo's plugins use them).
    # Adopt the new 26.05 defaults explicitly to silence the deprecation
    # warning (the old default was true while stateVersion < 26.05).
    withRuby = false;
    withPython3 = false;

    # copilot.vim needs `node` on PATH. Guarantee it for nvim everywhere,
    # including the headless Linux box which doesn't install nodejs globally.
    extraPackages = [ pkgs.nodejs ];

    # NOTE(clipboard-over-ssh): yanking to the *local* machine's clipboard from
    # nvim on the Linux box isn't wired up. xclip/wl-copy don't help over SSH (no
    # remote display); the fix is an OSC52 clipboard provider (neovim >=0.10 can
    # emit OSC52, terminal-emulator permitting). Deferred for now.

    plugins = sharedPlugins ++ neovimOnlyPlugins;

    extraConfig = vimrcContent;
    initLua = neovideConfig + "\n" + nvimLuaConfig;
  };

  # Vimrc that works for all vims (including MacVim)
  home.file.".vimrc".source = vimrcFull;

  # MacVim uses ~/.gvimrc directly
  home.file.".gvimrc".source = ./gvimrc;

  # Link nix plugin pack directory (for MacVim compatibility)
  home.file.".vim/nix-pack".source = packDir;

  # Link colorschemes, syntax, and ftdetect
  home.file.".vim/colors".source = ./colors;
  home.file.".vim/ftdetect".source = ./ftdetect;
  home.file.".vim/syntax".source = ./syntax;

  # Create writable directories for vim state
  home.activation.createVimDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.vim/undofiles
    mkdir -p $HOME/.vim/backup
  '';
}
