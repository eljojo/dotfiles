{
  config,
  pkgs,
  lib,
  self,
  vimfiles,
  ...
}:

let
in
{
  imports = [
    ./distributed-builds.nix
  ];

  # Required for flakes
  nixpkgs.hostPlatform = "aarch64-darwin";

  # necessary for beets :(
  nixpkgs.config.allowUnsupportedSystem = true;

  # terraform
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "jojo";
  users.users.jojo = {
    name = "jojo";
    home = "/Users/jojo";
  };

  home-manager.users.jojo =
    { pkgs, lib, ... }:
    {
      imports = [
        ./home-shared.nix
        vimfiles.homeManagerModules.vim
      ];

      home.packages = [
        pkgs.iperf3
        pkgs.go
        pkgs.yt-dlp
        pkgs.flyctl
        pkgs.beets
        (pkgs.callPackage ./tidal-dl.nix { })
        pkgs.ffmpeg_7-headless
        pkgs.ripgrep
        pkgs.nodejs
        pkgs.nixfmt-tree
        pkgs.ragenix
        pkgs.gh
        pkgs.nix-output-monitor
      ];

      home.stateVersion = "23.05";

      # macOS-specific git config
      programs.git.settings.credential.helper = "osxkeychain";

      # macOS-specific aliases (extend shared ones)
      home.shellAliases = {
        # YouTube (needs yt-dlp)
        youtube-audio = "yt-dlp -f 'ba' -x --audio-format mp3";
        youtube-video = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";

        # Darwin-specific nix commands (flake-based)
        nix-rebuild = "sudo darwin-rebuild switch --flake ~/.dotfiles";
        nix-update = "nix flake update ~/.dotfiles && sudo darwin-rebuild switch --flake ~/.dotfiles";
        nix-cleanup = lib.mkForce "nix-collect-garbage -d && brew cleanup";
      };

      # macOS-specific session variables (extend shared ones)
      home.sessionVariables = {
        BROWSER = "open";
        LSCOLORS = "ExFxCxDxBxegedabagacad";
        CLICOLOR = "true";
      };

      # macOS-specific paths (extend shared ones)
      home.sessionPath = lib.mkAfter [
        "$HOME/code/lisa/lab"
      ];

      # macOS-specific zsh additions (extend shared prezto config)
      programs.zsh = {
        # Add osx module to prezto
        prezto.pmodules = lib.mkAfter [ "osx" ];

        initContent = lib.mkAfter ''
          # Homebrew (macOS only)
          if [[ -d /opt/homebrew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          fi

          # macOS-specific extract formats (override shared extract)
          extract() {
            if [ -f $1 ]; then
              case $1 in
                *.tar.bz2) tar -jxvf $1 ;;
                *.tar.gz)  tar -zxvf $1 ;;
                *.bz2)     bunzip2 $1 ;;
                *.dmg)     hdiutil mount $1 ;;
                *.gz)      gunzip $1 ;;
                *.tar)     tar -xvf $1 ;;
                *.tbz2)    tar -jxvf $1 ;;
                *.tgz)     tar -zxvf $1 ;;
                *.zip|*.ZIP) unzip $1 ;;
                *.pax)     cat $1 | pax -r ;;
                *.pax.Z)   uncompress $1 --stdout | pax -r ;;
                *.Z)       uncompress $1 ;;
                *)         echo "'$1' cannot be extracted via extract()" ;;
              esac
            else
              echo "'$1' is not a valid file"
            fi
          }
        '';

      };

      # Ruby config
      home.file.".gemrc".text = ''
        ---
        :update_sources: true
        :verbose: true
        :backtrace: false
        :benchmark: false
        gem: --no-document
      '';

      home.file.".irbrc".text = ''
        #!/usr/bin/ruby
        require 'irb/completion'
        require 'rubygems'

        IRB.conf[:SAVE_HISTORY] = 1000
        IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
        IRB.conf[:PROMPT_MODE] = :SIMPLE
        IRB.conf[:AUTO_INDENT] = true

        class Object
          def local_methods(obj = self)
            (obj.methods - obj.class.superclass.instance_methods).sort
          end

          def ri(method = nil)
            unless method && method =~ /^[A-Z]/
              klass = self.kind_of?(Class) ? name : self.class.name
              method = [klass, method].compact.join('#')
            end
            puts `ri '#{method}'`
          end
        end

        def me
          User.find_by_login(ENV['USER'].strip)
        end

        def r
          reload!
        end
      '';

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

  environment.systemPackages = [
    pkgs.htop
    pkgs.silver-searcher
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
  homebrew.masApps = { # seems broken :( on m2
    #Tailscale = 1475387142;
    #"Home Assistant" = 1099568401;
    #"Day One" = 1055511498;
    #"Consent-O-Matic" = 1606897889;
    #StopTheMadness = 1376402589;
    # "MQTT Explorer" = 1455214828;
  };
  homebrew.brews = [
    "borgbackup"
  ];
  homebrew.casks = [
    "macvim"
    "neovide"
    "iterm2"
    "flycut"
    "syncthing"
    "discord"
    "signal"
    "vlc"
    "vorta"
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

  # Expose nix PATH to GUI apps (Neovide, etc.)
  launchd.user.envVariables.PATH = config.environment.systemPath;

  programs.zsh.enable = true;

  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;

  fonts.packages = with pkgs; [
    meslo-lgs-nf # for iTerm
    nerd-fonts.hack
  ];

  nix = {
    enable = true; # manage nix through nix-darwin
    package = pkgs.lix;
    settings.trusted-users = [ "jojo" ];

    # Register the flake in the registry - this makes it a GC root
    # so `nix-collect-garbage -d` won't nuke flake inputs
    registry.dotfiles.flake = self;
  };
  programs.nix-index.enable = true; # for comma

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # disabled auto-optimise-store = true due to https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
  nix.extraOptions = ''
    	  experimental-features = nix-command flakes
    	  ''
  + lib.optionalString (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") ''
    	  extra-platforms = x86_64-darwin aarch64-darwin
    	  '';
}
