#!/bin/bash

echo "> installing Firefox"
curl -Lo /tmp/Firefox.dmg "https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US";
hdiutil attach /tmp/Firefox.dmg;
ditto -rsrc /Volumes/Firefox/Firefox.app /Applications/Firefox.app;
hdiutil detach /Volumes/Firefox;
rm /tmp/Firefox.dmg;
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Spotify"
curl -Lo /tmp/spotify.dmg https://download.scdn.co/Spotify.dmg;
hdiutil attach /tmp/spotify.dmg;
ditto -rsrc /Volumes/Spotify/Spotify.app /Applications/Spotify.app;
hdiutil detach /Volumes/Spotify;
rm /tmp/spotify.dmg;
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spotify.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Roon"
curl -Lo /tmp/Roon.dmg "http://download.roonlabs.com/builds/Roon.dmg";
hdiutil attach /tmp/Roon.dmg;
ditto -rsrc /Volumes/Roon/Roon.app /Applications/Roon.app;
hdiutil detach /Volumes/Roon;
rm /tmp/Roon.dmg;
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Roon.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing MacVim"
brew cask install macvim
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/MacVim.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing 1Password from mac app store"
mas install 1333542190
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/1Password 7.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Tweetbot 3 from mac app store"
mas install 1384080005
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Tweetbot.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing iTerm 2"
curl -Lo /tmp/iterm2.zip https://iterm2.com/downloads/stable/iTerm2-3_3_6.zip;
unzip /tmp/iterm2.zip -d /tmp/
mv /tmp/iTerm.app /Applications/iTerm.app
rm /tmp/iterm2.zip
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Flycut"
brew cask install flycut

echo "> installing Syncthing"
curl -Lo /tmp/Syncthing.dmg "https://github.com/syncthing/syncthing-macos/releases/download/v1.0.0-2/Syncthing-1.0.0-2.dmg";
hdiutil attach /tmp/Syncthing.dmg;
ditto -rsrc /Volumes/Syncthing/Syncthing.app /Applications/Syncthing.app;
hdiutil detach /Volumes/Syncthing;
rm /tmp/Syncthing.dmg;

killall Dock
