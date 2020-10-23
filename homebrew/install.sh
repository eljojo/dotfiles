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
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# no analytics, please
brew analytics off

# Install homebrew packages
brew install grc coreutils spark the_silver_searcher git tree axel youtube-dl wget hub tmux zsh mas git-lfs fzf gpg parallel fortune

# https://www.boost.co.nz/blog/2018/01/improving-ruby-rails-debugging-ctags
# brew install --HEAD universal-ctags/universal-ctags/universal-ctags

# Upgrade homebrew
brew update

exit 0
