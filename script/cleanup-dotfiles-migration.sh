#!/bin/bash
# Cleanup script for dotfiles migration to home-manager
# Run this on other computers after pulling the new nix config

set -e

echo "Dotfiles Migration Cleanup Script"
echo "=================================="
echo ""
echo "This will remove old files that are now managed by nix/home-manager:"
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
[ -L "$HOME/.agignore" ] && items_to_delete+=("~/.agignore (old symlink)")
[ -L "$HOME/.gemrc" ] && items_to_delete+=("~/.gemrc (old symlink)")
[ -L "$HOME/.irbrc" ] && items_to_delete+=("~/.irbrc (old symlink)")
[ -L "$HOME/.tm_properties" ] && items_to_delete+=("~/.tm_properties (old symlink)")
[ -d "$HOME/.dotfiles/ruby" ] && items_to_delete+=("~/.dotfiles/ruby/ (old ruby configs)")
[ -d "$HOME/.dotfiles/system" ] && items_to_delete+=("~/.dotfiles/system/ (old system configs)")
[ -d "$HOME/.dotfiles/textmate" ] && items_to_delete+=("~/.dotfiles/textmate/ (old textmate configs)")
[ -d "$HOME/.dotfiles/homebrew" ] && items_to_delete+=("~/.dotfiles/homebrew/ (merged into bootstrap)")
[ -f "$HOME/.dotfiles/install_stuff_mac.sh" ] && items_to_delete+=("~/.dotfiles/install_stuff_mac.sh (merged into bootstrap)")
[ -f "$HOME/.dotfiles/script/setup-nix" ] && items_to_delete+=("~/.dotfiles/script/setup-nix (merged into bootstrap)")

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
    [ -L "$HOME/.agignore" ] && rm "$HOME/.agignore" && echo "Removed ~/.agignore"
    [ -L "$HOME/.gemrc" ] && rm "$HOME/.gemrc" && echo "Removed ~/.gemrc"
    [ -L "$HOME/.irbrc" ] && rm "$HOME/.irbrc" && echo "Removed ~/.irbrc"
    [ -L "$HOME/.tm_properties" ] && rm "$HOME/.tm_properties" && echo "Removed ~/.tm_properties"
    [ -d "$HOME/.dotfiles/ruby" ] && rm -rf "$HOME/.dotfiles/ruby" && echo "Removed ~/.dotfiles/ruby/"
    [ -d "$HOME/.dotfiles/system" ] && rm -rf "$HOME/.dotfiles/system" && echo "Removed ~/.dotfiles/system/"
    [ -d "$HOME/.dotfiles/textmate" ] && rm -rf "$HOME/.dotfiles/textmate" && echo "Removed ~/.dotfiles/textmate/"
    [ -d "$HOME/.dotfiles/homebrew" ] && rm -rf "$HOME/.dotfiles/homebrew" && echo "Removed ~/.dotfiles/homebrew/"
    [ -f "$HOME/.dotfiles/install_stuff_mac.sh" ] && rm "$HOME/.dotfiles/install_stuff_mac.sh" && echo "Removed ~/.dotfiles/install_stuff_mac.sh"
    [ -f "$HOME/.dotfiles/script/setup-nix" ] && rm "$HOME/.dotfiles/script/setup-nix" && echo "Removed ~/.dotfiles/script/setup-nix"
    echo ""
    echo "Done! Now run ./script/bootstrap to set up the system."
else
    echo "Aborted."
    exit 1
fi
