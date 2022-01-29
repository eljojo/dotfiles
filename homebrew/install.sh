#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

fi

if [ -d /opt/homebrew/bin ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# no analytics, please
brew analytics off

# Install homebrew packages
#brew install grc coreutils spark the_silver_searcher git tree axel youtube-dl wget hub tmux zsh mas git-lfs fzf gpg parallel fortune
brew install the_silver_searcher git tree wget tmux zsh mas git-lfs fzf gpg fortune

# Upgrade homebrew
brew update

exit 0
