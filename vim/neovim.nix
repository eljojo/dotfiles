# Shared neovim definition: plugin sets + config, consumed by both the
# home-manager module (vim/module.nix, for the Mac) and the NixOS module
# (vim/nixos.nix, to drop a configured `nvim` onto a host system-wide — e.g. root).
# `package` is a self-contained, wrapped neovim that needs no home-manager.
{
  pkgs,
  lib ? pkgs.lib,
}:

let
  # Custom plugins not in nixpkgs.
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

  # vim-yankstack: currently DISABLED in sharedPlugins (jojo wasn't using the
  # <M-p>/<M-P> yank-ring cycling); kept here so re-enabling is one uncomment.
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

  # Plugins common to BOTH editors AND the slim server build. Deliberately EXCLUDES
  # vim-ruby + copilot-vim (those live in fullOnlyPlugins) so the slim set can be
  # built without ever referencing them — vim-ruby is nixpkgs-unfree, and merely
  # referencing an unfree derivation triggers the unfree check even to filter it out.
  sharedPluginsCommon = with pkgs.vimPlugins; [
    vim-sensible
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
    # vim-yankstack  # disabled 2026-06-12 — see derivation note above.
    vim-javascript
    yats-vim # TypeScript + .tsx syntax
    indentLine
    fzf-wrapper
    fzf-vim
    vim-nix
  ];

  # Plugins the full (Mac) build adds but the slim server build drops:
  #   vim-ruby    - ruby ftplugin/syntax (also the only nixpkgs-unfree plugin here)
  #   copilot-vim - AI completion (the only reason node is needed)
  fullOnlyPlugins = with pkgs.vimPlugins; [
    vim-ruby
    copilot-vim
  ];

  # Full shared set for BOTH editors (MacVim packDir + Mac neovim).
  sharedPlugins =
    sharedPluginsCommon
    ++ fullOnlyPlugins
    # markdown-preview: only on macOS (the Linux box is headless SSH, no browser).
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      pkgs.vimPlugins.markdown-preview-nvim
    ];

  # Lua-native plugins that load ONLY in neovim (never in MacVim's packDir).
  neovimOnlyPlugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    indent-blankline-nvim
    fzf-lua
    nvim-solarized-lua
  ];

  # Classic plugins replaced by an nvim-native equivalent — dropped from the
  # neovim set so both don't load. MacVim's packDir keeps the full sharedPlugins.
  nvimReplaced = with pkgs.vimPlugins; [
    indentLine
    vim-commentary
    vim-colors-solarized
  ];

  # The neovim plugin set: shared minus the replaced classics, plus the nvim-only ones.
  neovimPlugins =
    builtins.filter (p: !(builtins.elem p nvimReplaced)) sharedPlugins
    ++ neovimOnlyPlugins;

  # Shared vimscript config (loads in both editors).
  vimrcContent = builtins.readFile ./vimrc;

  # neovim-only Lua: Neovide GUI tweaks + the nvim plugin layer (treesitter,
  # solarized, indent-blankline, fzf-lua keymaps). Runs AFTER the vimrc.
  initLua = builtins.readFile ./init-neovide.lua + "\n" + builtins.readFile ./init-nvim.lua;

  # copilot.vim needs node on PATH.
  extraPackages = [ pkgs.nodejs ];

  # Self-contained configured neovim (no home-manager). The vimscript rc is sourced
  # explicitly FROM lua so it loads before the lua layer (whose keymaps must win) —
  # wrapNeovim's own rc ordering is the reverse of home-manager's, so don't rely on it.
  vimrcFile = pkgs.writeText "init-shared.vim" vimrcContent;
  mkPackage =
    {
      plugins,
      extraBin ? [ ],
    }:
    let
      cfg = pkgs.neovimUtils.makeNeovimConfig {
        withRuby = false;
        withPython3 = false;
        withNodeJs = false; # any extras go on PATH via extraBin, not as provider hosts
        plugins = map (p: { plugin = p; }) plugins;
      };
    in
    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
      cfg
      // {
        luaRcContent = cfg.luaRcContent + "\nvim.cmd.source('${vimrcFile}')\n" + initLua;
        wrapperArgs =
          cfg.wrapperArgs
          ++ lib.optionals (extraBin != [ ]) [
            "--suffix"
            "PATH"
            ":"
            (lib.makeBinPath extraBin)
          ];
      }
    );

  # Slim neovim set for root on servers: the common plugins (NOT vim-ruby/copilot)
  # minus the nvim-replaced classics, plus the nvim-only Lua plugins. Built from
  # sharedPluginsCommon so it never references the unfree vim-ruby.
  slimPlugins =
    builtins.filter (p: !(builtins.elem p nvimReplaced)) sharedPluginsCommon
    ++ neovimOnlyPlugins;

  # Full package (everything; node on PATH for copilot).
  package = mkPackage {
    plugins = neovimPlugins;
    extraBin = [ pkgs.nodejs ];
  };

  # Lightweight package for root on servers: no ruby, no copilot, no node, no unfree.
  slimPackage = mkPackage { plugins = slimPlugins; };

in
{
  inherit
    sharedPlugins
    neovimOnlyPlugins
    neovimPlugins
    vimrcContent
    initLua
    extraPackages
    package
    slimPackage
    ;
}
