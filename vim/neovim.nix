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

  # Plugins for BOTH MacVim and neovim (classic vimscript, work everywhere).
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
      # vim-yankstack  # disabled 2026-06-12 — see derivation note above.
      vim-javascript
      yats-vim # TypeScript + .tsx syntax
      indentLine
      fzf-wrapper
      fzf-vim
      vim-nix
      copilot-vim
    ])
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

  # Self-contained configured neovim (no home-manager). Used by the NixOS module.
  # The vimscript rc is sourced explicitly FROM lua so it loads before the lua
  # layer (whose keymaps must win) — wrapNeovim's own rc ordering is the reverse
  # of home-manager's, so we don't rely on it.
  vimrcFile = pkgs.writeText "init-shared.vim" vimrcContent;
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withRuby = false;
    withPython3 = false;
    withNodeJs = false; # node is added to PATH below, not as a provider host
    plugins = map (p: { plugin = p; }) neovimPlugins;
  };
  package = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
    neovimConfig
    // {
      luaRcContent =
        neovimConfig.luaRcContent
        + "\nvim.cmd.source('${vimrcFile}')\n"
        + initLua;
      wrapperArgs = neovimConfig.wrapperArgs ++ [
        "--suffix"
        "PATH"
        ":"
        (lib.makeBinPath [ pkgs.nodejs ])
      ];
    }
  );

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
    ;
}
