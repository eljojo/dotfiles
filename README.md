# jojo does dotfiles

Your dotfiles are how you personalize your system. These are mine.

This repo has evolved over the years - originally forked from [Zach Holman's dotfiles](https://github.com/holman/dotfiles) (which itself built on [Ryan Bates'](http://github.com/ryanb/dotfiles)), it started as a symlink-based setup with topic directories. In 2026, I migrated to Nix and home-manager for declarative, reproducible configuration.

**This is shared for educational purposes.** Don't run it verbatim - fork it, read through it, take what's useful, and make it your own. That's the dotfiles way.

## Quick start (macOS)

```sh
git clone https://github.com/eljojo/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/bootstrap
```

The bootstrap script is idempotent (safe to run multiple times) and sets up:
- Homebrew
- Lix (Nix)
- nix-darwin + home-manager
- Vim with plugins
- SSH key
- macOS defaults (optional)
- A few apps (Firefox, Spotify, 1Password, etc.)

## How it works (Nix / home-manager)

The repo is a Nix flake that exports a home-manager module. This module configures:

- **Git**: name, email, aliases (`co`, `lg`, `count`), global ignores, sensible defaults (rebase on pull, prune on fetch, etc.)
- **Shell aliases**: git shortcuts (`st`, `gd`, `push`, `pull`), typo fixes (`sl`, `grpe`), safe `rm`/`cp`/`mv`
- **Zsh**: prezto + powerlevel10k prompt, history substring search, autosuggestions, syntax highlighting
- **Helper functions**: `c` for quick project navigation, `extract` for archives, `gf` to checkout remote branches
- **Session variables**: `GOPATH`, `PROJECTS`, `VISUAL`, `PAGER`

### Using it

Add as a flake input and import the module:

```nix
# In your flake.nix inputs:
dotfiles = {
  url = "github:eljojo/dotfiles";
  inputs.nixpkgs.follows = "nixpkgs";
};

# In your home-manager config:
home-manager.users.yourname = {
  imports = [ inputs.dotfiles.homeModule ];
  home.stateVersion = "23.05";

  # Override or extend anything here
};
```

The interesting bits are in:
- `flake.nix` - exports the home-manager module
- `nix/home-shared.nix` - the actual configuration
- `config/p10k.zsh` - powerlevel10k prompt config

## iTerm2 Solarized colors

```sh
cd ~
wget https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Light.itermcolors
wget https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
open *.itermcolors
rm -f *.itermcolors
```

## Lineage

```
Ryan Bates' dotfiles
        ↓
Zach Holman's dotfiles (topical organization, symlinks)
        ↓
This repo (2014: fork, customize)
        ↓
This repo (2026: migrate to Nix/home-manager)
```
