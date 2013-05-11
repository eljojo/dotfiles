#!/bin/sh
cd ~/.vim
git submodule init
git submodule update
git submodule foreach git checkout master
ln -s ~/.vim/vimrc ~/.vimrc
cd ~/.vim/bundle/command-t/ruby/command-t/
/usr/bin/ruby extconf.rb
make

