# vimfiles

These are my vim files and this, my dear reader, is a turtle.
```
                         .---.           _....._
-------------------\    /  p  `\     .-""`:     :`"-.
| v i i i i i m m m \  |__   - |  ,'     .     '    ',
-----------------------   ._>    \ /:      :     ;      :,
                          '-.    '\`.     .     :     '  \
                             `.   | .'._.' '._.' '._.'.  |
                               `;-\.   :     :     '   '/,__,
                               .-'`'._ '     .     : _.'.__.'
                              ((((-'/ `";--..:..--;"` \
                                  .'   /           \   \
                                 ((((-'           ((((-'
```

## Setup

This repo is a [Nix flake](https://nixos.wiki/wiki/Flakes) that provides a home-manager module for vim/neovim configuration.

### With home-manager (recommended)

Add to your flake inputs:

```nix
{
  inputs.vimfiles = {
    url = "github:eljojo/vimfiles";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Import the module in your home-manager config:

```nix
home-manager.users.jojo = {
  imports = [ inputs.vimfiles.homeModule ];
};
```

### macOS with nix-darwin (non-flake)

In your `darwin-configuration.nix`:

```nix
home-manager.users.jojo = {
  imports = [
    /path/to/vimfiles/module.nix
  ];
};
```

## What it does

- Configures `programs.vim` and `programs.neovim` with plugins managed by nix
- Creates `~/.vimrc` that sets up plugin paths (for MacVim compatibility)
- Creates `~/.gvimrc` for MacVim GUI settings
- Creates `~/.vim/nix-pack` symlink to nix plugin directory
- Configures neovide-specific keybindings (Cmd+S, Cmd+V, etc.)

## Supported editors

- **Terminal vim** - via `programs.vim`
- **Neovim/Neovide** - via `programs.neovim`
- **MacVim** - uses `~/.vimrc` and `~/.gvimrc`, finds plugins via `~/.vim/nix-pack`

## Plugins

Plugins are defined in `module.nix` and managed entirely by nix. No more Vundle or manual plugin installation.

## Repo location

This repo should live at `~/code/vimfiles` (not `~/.vim`). Home-manager creates and manages `~/.vim`.

## Migration from old setup

If you previously had this cloned to `~/.vim`:

1. Move the repo: `mv ~/.vim ~/code/vimfiles`
2. Run `darwin-rebuild switch` or `home-manager switch`
3. Or use the cleanup script in dotfiles: `./scripts/cleanup-dotfiles-migration.sh`
