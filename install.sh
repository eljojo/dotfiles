#!/bin/sh
cd ~/.vim
git submodule init
git submodule update
git submodule foreach git checkout master
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/gvimrc ~/.gvimrc

