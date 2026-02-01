{
  config,
  pkgs,
  lib,
  ...
}:

let
in
{
  imports = [
    <home-manager/nix-darwin>
    ./distributed-builds.nix
  ];

  # necessary for beets :(
  nixpkgs.config.allowUnsupportedSystem = true;

  # terraform
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.config.packageOverrides = pkgs: rec {
  #   beets = pkgs.beets
  #   .override({
  #      pluginOverrides = {
  #        copyartifacts = { enable = true; propagatedBuildInputs = [ pkgs.beetsPackages.copyartifacts ]; };
  #        limit = { builtin = true; };
  #        # absubmit = { builtin = true; };
  #      };
  #    });
  #   keyfinder-cli = pkgs.keyfinder-cli.overrideAttrs (_: { meta.platforms = lib.platforms.darwin ++ lib.platforms.linux; });
  # };

  system.primaryUser = "jojo";
  users.users.jojo = {
    name = "jojo";
    home = "/Users/jojo";
  };
  home-manager.users.jojo =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.iperf3
        pkgs.go
        pkgs.yt-dlp
        pkgs.flyctl
        pkgs.beets
        (pkgs.callPackage ./tidal-dl.nix { })
        # pkgs.terraform
        # pkgs.cf-terraforming
        #pkgs.kubectl
        pkgs.ffmpeg_7-headless
        pkgs.ripgrep
        pkgs.nodejs
        pkgs.nixfmt-tree
        pkgs.ragenix
        pkgs.gh
        pkgs.nix-output-monitor
      ];
      home.stateVersion = "23.05";
      programs.home-manager.enable = true;

      programs.git = {
        enable = true;
        lfs.enable = true;

        settings = {
          user = {
            name = "José Albornoz";
            email = "jojo@eljojo.net";
          };
          alias = {
            co = "checkout";
            count = "shortlog -sn";
            lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
          };
          credential.helper = "osxkeychain";
          core = {
            editor = "vim";
            trustctime = false;
            pager = "less -r";
          };
          color.ui = true;
          push = {
            default = "simple";
            autoSetupRemote = true;
          };
          pull.rebase = true;
          fetch.prune = true;
          branch.autosetuprebase = "always";
          rerere.enabled = true;
          help.autocorrect = 1;
          init.defaultBranch = "main";
          diff.indentHeuristic = true;
          merge.conflictstyle = "diff3";
        };

        ignores = [
          # OS
          ".DS_Store"
          ".DS_Store?"
          "._*"
          ".Spotlight-V100"
          ".Trashes"
          "Thumbs.db"
          ".AppleDouble"
          ".LSOverride"
          ".AppleDB"
          ".AppleDesktop"
          "Network Trash Folder"
          "Temporary Items"
          ".apdisk"
          ".directory"
          # Editor
          "*~"
          "*.swp"
          # Compiled
          "*.o"
          "*.so"
          "*.a"
          "*.class"
          "*.exe"
          "*.dll"
          "*.com"
          # Archives
          "*.7z"
          "*.dmg"
          "*.gz"
          "*.iso"
          "*.jar"
          "*.rar"
          "*.tar"
          "*.zip"
          # Logs/DB
          "*.log"
          "*.sqlite"
          "dump.rdb"
          # Ruby
          "*.gem"
          "*.rbc"
          ".bundle/"
          ".byebug_history"
          # Go
          "_obj"
          "_test"
          "*.test"
          "*.prof"
          # Elixir
          "/_build"
          "/deps"
          "erl_crash.dump"
          "*.ez"
        ];
      };

      home.shellAliases = {
        # Git shortcuts
        st = "git status";
        gd = "git diff";
        push = "git push origin HEAD";
        pull = "git pull";
        co = "git checkout";
      };

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
  environment.systemPackages = [
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
    # Transmit = 1436522307;
    "Home Assistant" = 1099568401;
    "Day One" = 1055511498;
    # Telegram = 747648890;
    # "Microsoft Remote Desktop" = 1295203466;
    "Consent-O-Matic" = 1606897889;
    StopTheMadness = 1376402589;
    # NotionWebClipper = 1559269364;
    # TweaksForTwitter = 1567751529;
  };
  homebrew.casks = [
    "macvim"
    "neovide"
    "iterm2"
    "flycut"
    "syncthing"
    # "iina"
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

  # Expose nix PATH to GUI apps (Neovide, etc.)
  launchd.user.envVariables.PATH = config.environment.systemPath;

  programs.zsh.enable = true;
  programs.zsh.enableSyntaxHighlighting = true;
  programs.zsh.enableFzfHistory = true;

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
  };
  programs.nix-index.enable = true; # for comma

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "/Users/jojo/.dotfiles/nix/darwin-configuration.nix";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # disabled auto-optimise-store = true due to https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
  nix.extraOptions = ''
    	  experimental-features = nix-command flakes
    	  ''
  + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    	  extra-platforms = x86_64-darwin aarch64-darwin
    	  '';
}
