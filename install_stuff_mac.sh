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

echo "> installing MacVim"
curl -Lo /tmp/macvim.dmg https://github.com/macvim-dev/macvim/releases/download/snapshot-153/MacVim.dmg;
hdiutil attach /tmp/macvim.dmg;
ditto -rsrc /Volumes/MacVim/MacVim.app /Applications/MacVim.app;
hdiutil detach /Volumes/MacVim;
rm /tmp/macvim.dmg;
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/MacVim.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing 1Password from mac app store"
mas install 1333542190
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/1Password 7.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Tweetbot 3 from mac app store"
mas install 1384080005

echo "> installing iTerm 2"
curl -Lo /tmp/iterm2.zip https://iterm2.com/downloads/stable/iTerm2-3_3_6.zip;
unzip /tmp/iterm2.zip -d /tmp/
mv /tmp/iTerm.app /Applications/iTerm.app
rm /tmp/iterm2.zip
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

brew cask install flycut
echo "> installing Flycut"
curl -Lo /tmp/flycut.zip https://github.com/TermiT/Flycut/releases/download/1.9.4/Flycut.app.1.9.4.zip;
unzip /tmp/flycut.zip -d /tmp/
mv /tmp/Flycut.app /Applications/Flycut.app
rm /tmp/flycut.zip

killall Dock
