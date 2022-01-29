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
brew install --cask macvim
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/MacVim.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing 1Password from mac app store"
mas install 1333542190
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/1Password 7.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Tweetbot 3 from mac app store"
mas install 1384080005
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Tweetbot.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Telegram"
mas install 747648890

echo "> installing iTerm 2"
brew install --cask iterm2
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Flycut"
brew install --cask flycut

echo "> installing Syncthing"
brew install --cask syncthing

killall Dock

echo "> installing Day One"
mas install 1055511498

# echo "> installing IINA video player"
# brew install --cask iina

echo "> installing VLC"
brew install --cask vlc

echo "> installing Skype"
brew install --cask skype

echo "> installing Home Assistant"
mas install 1099568401

echo "> installing Transmit"
mas install 1436522307

echo "> installing Tailscale"
mas install 1475387142

echo "> installing MQTT Explorer"
mas install 1455214828
