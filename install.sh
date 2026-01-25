#!/bin/sh
cd ~/.vim

# Vim symlinks
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/gvimrc ~/.gvimrc

# Neovim setup
mkdir -p ~/.config/nvim
ln -sf ~/.vim/init.lua ~/.config/nvim/init.lua

# Install Vundle and plugins
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Build markdown-preview.nvim
cd ~/.vim/bundle/markdown-preview.nvim/app && npm install
