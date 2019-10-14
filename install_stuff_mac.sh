#!/bin/bash

 echo "> installing Google Chrome"
 curl -Lo /tmp/Google\ Chrome.dmg https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg;
 hdiutil attach /tmp/Google\ Chrome.dmg;
 ditto -rsrc /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/Google\ Chrome.app;
 hdiutil detach /Volumes/Google\ Chrome;
 rm /tmp/Google\ Chrome.dmg;
 defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
 
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

echo "> installing Tweetbo 3 from mac app store"
mas install 1384080005

echo "> installing iTerm 2"
curl -Lo /tmp/iterm2.zip https://iterm2.com/downloads/stable/iTerm2-3_2_6.zip;
unzip /tmp/iterm2.zip -d /tmp/
mv /tmp/iTerm.app /Applications/iTerm.app
rm /tmp/iterm2.zip
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

echo "> installing Flycut"
curl -Lo /tmp/flycut.zip https://github.com/TermiT/Flycut/releases/download/1.8.2/Flycut.app.1.8.2.zip;
unzip /tmp/flycut.zip -d /tmp/
mv /tmp/Flycut.app /Applications/Flycut.app
rm /tmp/flycut.zip

killall Dock
