{ config, pkgs, lib, ... }:

let
in {
  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.defaults.NSGlobalDomain.KeyRepeat = 1; # very fast key repeat
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 25;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false; # disable accent thingy
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3; # "Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  # system.defaults.universalaccess.closeViewScrollWheelToggle = true; # Accessibility: zoom with ctrl - broken?

  # Trackpad
  system.defaults.trackpad.FirstClickThreshold = 2; # trackpad: "Firm" force touch pressure
  system.defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = 1; # trackpad: tap to click
  system.defaults.trackpad.Clicking = true;

  # Finder
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true; # dark mode at night
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false; # Finder: don't warn when renaming files
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.LaunchServices.LSQuarantine = false; # Disable the “Are you sure you want to open this application?” dialog
  homebrew.caskArgs.no_quarantine = true;

  # Dock
  system.defaults.dock.show-process-indicators = false;
  system.defaults.dock.show-recents = true;
  system.defaults.dock.showhidden = true; # Whether to make icons of hidden applications tranclucent.

  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.NSGlobalDomain.AppleMetricUnits = 1;
  system.defaults.NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
  system.defaults.NSGlobalDomain.AppleTemperatureUnit = "Celsius";

  # Hot Corners - https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-bl-corner
  system.defaults.dock.wvous-tl-corner = 2; # Top left corner → Mission Control
  system.defaults.dock.wvous-bl-corner = 4; # Bottom left screen corner → Desktop
}
