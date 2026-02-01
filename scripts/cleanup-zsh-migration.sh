#!/bin/bash
# Cleanup script for ZSH migration to home-manager
# Run this on other computers after pulling the new nix config

set -e

echo "ZSH Migration Cleanup Script"
echo "============================="
echo ""
echo "This will remove old zsh files that are now managed by nix/home-manager:"
echo ""

# List what will be deleted
items_to_delete=()

[ -d "$HOME/.zprezto" ] && items_to_delete+=("~/.zprezto/ (prezto git repo)")
[ -d "$HOME/.dotfiles/zsh" ] && items_to_delete+=("~/.dotfiles/zsh/ (old zsh configs)")
[ -d "$HOME/.dotfiles/functions" ] && items_to_delete+=("~/.dotfiles/functions/ (old shell functions)")
[ -L "$HOME/.zshrc" ] && items_to_delete+=("~/.zshrc (old symlink)")
[ -L "$HOME/.zshenv" ] && items_to_delete+=("~/.zshenv (old symlink)")
[ -L "$HOME/.zprofile" ] && items_to_delete+=("~/.zprofile (old symlink)")
[ -L "$HOME/.zpreztorc" ] && items_to_delete+=("~/.zpreztorc (old symlink)")
[ -L "$HOME/.zlogin" ] && items_to_delete+=("~/.zlogin (old symlink)")
[ -L "$HOME/.zlogout" ] && items_to_delete+=("~/.zlogout (old symlink)")

if [ ${#items_to_delete[@]} -eq 0 ]; then
    echo "Nothing to clean up! All old files already removed."
    exit 0
fi

for item in "${items_to_delete[@]}"; do
    echo "  - $item"
done

echo ""
read -p "Delete these files? [y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    [ -d "$HOME/.zprezto" ] && rm -rf "$HOME/.zprezto" && echo "Removed ~/.zprezto/"
    [ -d "$HOME/.dotfiles/zsh" ] && rm -rf "$HOME/.dotfiles/zsh" && echo "Removed ~/.dotfiles/zsh/"
    [ -d "$HOME/.dotfiles/functions" ] && rm -rf "$HOME/.dotfiles/functions" && echo "Removed ~/.dotfiles/functions/"
    [ -L "$HOME/.zshrc" ] && rm "$HOME/.zshrc" && echo "Removed ~/.zshrc"
    [ -L "$HOME/.zshenv" ] && rm "$HOME/.zshenv" && echo "Removed ~/.zshenv"
    [ -L "$HOME/.zprofile" ] && rm "$HOME/.zprofile" && echo "Removed ~/.zprofile"
    [ -L "$HOME/.zpreztorc" ] && rm "$HOME/.zpreztorc" && echo "Removed ~/.zpreztorc"
    [ -L "$HOME/.zlogin" ] && rm "$HOME/.zlogin" && echo "Removed ~/.zlogin"
    [ -L "$HOME/.zlogout" ] && rm "$HOME/.zlogout" && echo "Removed ~/.zlogout"
    echo ""
    echo "Done! Now run darwin-rebuild switch to apply the new config."
else
    echo "Aborted."
    exit 1
fi
