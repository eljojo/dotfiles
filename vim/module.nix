# Home-manager module for vim/neovim configuration
{ config, lib, pkgs, ... }:

let
  # Build plugins not in nixpkgs
  vim-bundler = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-bundler";
    version = "2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-bundler";
      rev = "c261509e78fc8dc55ad1fcf3cd7cdde49f35435c";
      sha256 = "sha256-z8ZQhCITVxW+RShX5drAQm4aKFWT5K3yw72nBcwVGa4=";
    };
  };

  vim-rubocop = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-rubocop";
    version = "2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "ngmy";
      repo = "vim-rubocop";
      rev = "1c57918086d22cc9db829125f6b78226feae86a3";
      sha256 = "sha256-p7GaFu6gVIDT6OI0VmHfXefbzX/Q9G1Ec7BUN88eW0Y=";
    };
  };

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
  sharedPlugins = with pkgs.vimPlugins; [
    vim-sensible
    vim-ruby
    syntastic
    vim-easymotion
    nerdtree
    vim-rails
    vim-coffee-script
    vim-markdown
    vim-endwise
    delimitMate
    vim-bundler
    ag-vim
    vim-rhubarb
    vim-fugitive
    vim-go
    vim-colors-solarized
    vim-commentary
    vim-elixir
    vim-surround
    camelcasemotion
    vim-rubocop
    rainbow_parentheses-vim
    vim-yankstack
    vim-javascript
    indentLine
    fzfWrapper
    fzf-vim
    vim-nix
    copilot-vim
    markdown-preview-nvim
  ];

  # Shared vimrc content (stripped of Vundle)
  vimrcContent = builtins.readFile ./vimrc;

  # Neovide-specific lua config
  neovideConfig = builtins.readFile ./init-neovide.lua;

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

in {
  # Configure vim
  programs.vim = {
    enable = true;
    plugins = sharedPlugins;
    extraConfig = vimrcContent;
  };

  # Configure neovim (for Neovide)
  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;

    plugins = sharedPlugins;

    extraConfig = vimrcContent;
    extraLuaConfig = neovideConfig;
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
