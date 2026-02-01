# Sets reasonable OS X defaults.
#
# Or, in other words, set shit how I like in OS X.
#
# The original idea (and a couple settings) were grabbed from:
# - https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# - https://gist.github.com/brandonb927/3195465
#
# Run ./set-defaults.sh and you'll be good to go.

# Set the Finder prefs for showing a few different volumes on the Desktop.
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Locale: 24-hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Calendar: Week starts on Monday
defaults write com.apple.iCal "first day of week" -int 1

# Top left corner → Mission Control - MANAGED BY NIX (system.defaults.dock.wvous-tl-corner)

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# "Remove duplicates in the "Open With" menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Trackpad: Swipe between full-screen apps
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 2

defaults write com.apple.dock showAppExposeGestureEnabled -bool true
# defaults write com.apple.dock showMissionControlGestureEnabled -bool true
# defaults write com.apple.dock showDesktopGestureEnabled -bool true
# defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

# Use scroll gesture with the Ctrl (^) modifier key to zoom - https://developer.apple.com/documentation/devicemanagement/accessibility
sudo defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

# Finder: New window points to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Finder: "Avoiding the creation of .DS_Store files on network volumes"
# https://support.apple.com/en-ca/HT208209
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Desktop
defaults write com.apple.Finder FXPreferredGroupBy Kind # group desktop icons by kind
# TODO: use stacks

# Dock: autohiding dock
# defaults write com.apple.dock autohide -bool true

# Dock: Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
# defaults write com.apple.dock tilesize -int 30

# Dock: enable dock magnification
# defaults write com.apple.dock magnification -bool true

# Dock: magnified size of dock icons
# defaults write com.apple.dock largesize -int 100

# Mail: "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Safari Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Safari: Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Safari: Show the full URL in the address bar (note: this still hides the scheme)
# defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Safari: Press Tab to highlight each item on a web page
# defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Safari: Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Mail: Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Terminal: Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Time Machine: Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Photos: Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Messages: Disable smart quotes
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Finder: Default view for new windows
# defaults write com.apple.finder FXPreferredViewStyle Clmv # for column view
# defaults write com.apple.Finder FXPreferredViewStyle Nlsv # for list view
