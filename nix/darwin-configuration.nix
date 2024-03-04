{ config, pkgs, lib, ... }:

let
in {
  imports = [ <home-manager/nix-darwin> ];

  # necessary for beets :(
  nixpkgs.config.allowUnsupportedSystem = true;

  # terraform
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: rec {
    # beets-unstable = pkgs.beets-unstable
    # .override({
    #    pluginOverrides = {
    #      copyartifacts = { enable = true; propagatedBuildInputs = [ pkgs.beetsPackages.copyartifacts ]; };
    #      limit = { builtin = true; };
    #      absubmit = { builtin = true; };
    #    };
    #  });
    keyfinder-cli = pkgs.keyfinder-cli.overrideAttrs (_: { meta.platforms = lib.platforms.darwin ++ lib.platforms.linux; });
  };

  users.users.jojo = {
    name = "jojo";
    home = "/Users/jojo";
  };
  home-manager.users.jojo = { pkgs, ... }: {
    home.packages = [
      pkgs.iperf3
      pkgs.go
      pkgs.yt-dlp
      pkgs.flyctl
      # pkgs.beets-unstable
      (pkgs.callPackage ./tidal-dl.nix {})
      # pkgs.terraform
      # pkgs.cf-terraforming
      pkgs.kubectl
    ];
    home.stateVersion = "23.05";
    programs.home-manager.enable = true;

    xdg.dataFile."postgresql/.keep".text = ""; # Create ~/.local/share/postgresql/
    xdg.dataFile."redis/.keep".text = ""; # Create ~/.local/share/redis/
  };
  home-manager.useGlobalPkgs = true; # we may want to move away from unstable in global at some point in the future

  services.redis.enable = true;
  services.redis.dataDir = "/Users/jojo/.local/share/redis/";

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14.withPackages (p: [ p.postgis ]);
    dataDir = "/Users/jojo/.local/share/postgresql/data/";
  };

  # create default user with `psql -U postgres` and `CREATE USER jojo SUPERUSER;`

  # launchd.user.agents.postgresql.serviceConfig = {
  #   StandardErrorPath = "/Users/jojo/.local/share/postgresql/postgres.error.log";
  #   StandardOutPath = "/Users/jojo/.local/share/postgresql/postgres.out.log";
  # };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.htop
      pkgs.silver-searcher
      # pkgs.darwin-zsh-completions
      pkgs.curl
      pkgs.wget
      pkgs.git
      pkgs.comma
      pkgs.vim
      pkgs.fortune
      pkgs.tree
      pkgs.git-lfs
      pkgs.fzf
    ];

  homebrew.enable = true;
  homebrew.masApps = {
    Tailscale = 1475387142;
    Transmit = 1436522307;
    "Home Assistant" = 1099568401;
    "Day One" = 1055511498;
    Telegram = 747648890;
    "Microsoft Remote Desktop" = 1295203466;
    "Consent-O-Matic" = 1606897889;
    StopTheMadness = 1376402589;
    NotionWebClipper = 1559269364;
    TweaksForTwitter = 1567751529;
  };
  homebrew.casks = [
    "macvim"
    "iterm2"
    "flycut"
    "syncthing"
    "iina"
    "skype"
    "notion"
    "discord"
    "signal"
    # "utm"
    # "private-internet-access" # kinda broken
  ];

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

  environment.variables.EDITOR = "${pkgs.vim}/bin/vim";

  programs.zsh.enable = true;
  programs.zsh.enableSyntaxHighlighting = true;
  programs.zsh.enableFzfHistory = true;

  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     meslo-lgs-nf # for iTerm
    (nerdfonts.override { fonts = [ "Hack" ]; })
   ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true; # for comma

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.dotfiles/nix/darwin-configuration.nix";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.extraOptions = ''
	  auto-optimise-store = true
	  experimental-features = nix-command flakes
	  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
	  extra-platforms = x86_64-darwin aarch64-darwin
	  '';
}
