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

Import the module in your home-manager config:

```nix
home-manager.users.jojo = {
  imports = [ inputs.dotfiles.homeManagerModules.vim ];
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

## Thanks

Between 2013-2026 this code lived under https://github.com/eljojo/vimfiles
It was originally based on scrooloose's excellent vimfiles: https://github.com/scrooloose/vimfiles 
