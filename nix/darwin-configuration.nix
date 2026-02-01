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

        # Network
        pi = "ping 8.8.8.8";

        # Typo fixes
        sl = "ls";
        chmdo = "chmod";
        icfonfig = "ifconfig";
        ifocnfig = "ifconfig";
        mann = "man";
        act = "cat";
        cart = "cat";
        grpe = "grep";
        gpre = "grep";

        # Safe defaults
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        ln = "ln -i";

        # YouTube
        youtube-audio = "yt-dlp -f 'ba' -x --audio-format mp3";
        youtube-video = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";

        # Nix maintenance
        nix-rebuild = "sudo darwin-rebuild switch -I darwin-config=$HOME/.dotfiles/nix/darwin-configuration.nix";
        nix-update = "sudo nix-channel --update && sudo darwin-rebuild switch -I darwin-config=$HOME/.dotfiles/nix/darwin-configuration.nix";
        nix-cleanup = "nix-collect-garbage -d && brew cleanup";
      };

      home.sessionVariables = {
        GOPATH = "$HOME/.go";
        PROJECTS = "$HOME/code";
        BROWSER = "open";
        VISUAL = "vim";
        PAGER = "less";
        LESS = "-F -g -i -M -R -S -w -X -z-4";
        LSCOLORS = "ExFxCxDxBxegedabagacad";
        CLICOLOR = "true";
      };
      home.sessionPath = [
        "$HOME/.go/bin"
        "$HOME/.bin"
        "$HOME/code/lisa/lab"
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        historySubstringSearch.enable = true;
        autosuggestion.enable = true;

        prezto = {
          enable = true;
          color = true;
          pmodules = [
            "environment"
            "terminal"
            "editor"
            "history"
            "directory"
            "spectrum"
            "utility"
            "completion"
            "prompt"
            "osx"
            "ssh"
            "archive"
            "command-not-found"
            "history-substring-search"
            "autosuggestions"
          ];
          editor = {
            keymap = "emacs";
            dotExpansion = true;
          };
          prompt.theme = "powerlevel10k";
          terminal.autoTitle = true;
          autosuggestions.color = "fg=6";
        };

        history = {
          size = 10000;
          save = 10000;
          extended = true;
          ignoreDups = true;
          ignoreAllDups = true;
          share = true;
        };

        setOptions = [
          "NO_BG_NICE"
          "NO_HUP"
          "NO_LIST_BEEP"
          "LOCAL_OPTIONS"
          "LOCAL_TRAPS"
          "HIST_VERIFY"
          "PROMPT_SUBST"
          "CORRECT"
          "COMPLETE_IN_WORD"
          "APPEND_HISTORY"
          "INC_APPEND_HISTORY"
          "HIST_REDUCE_BLANKS"
          "complete_aliases"
        ];

        shellAliases = {
          "reload!" = ". ~/.zshrc";
        };

        envExtra = ''
          # Secrets
          [ -f ~/.env-vars ] && source ~/.env-vars
          [ -f ~/.localrc ] && source ~/.localrc

          # Temp directory
          if [[ ! -d "$TMPDIR" ]]; then
            export TMPDIR="/tmp/$USER"
            mkdir -p -m 700 "$TMPDIR"
          fi

          TMPPREFIX="''${TMPDIR%/}/zsh"
          if [[ ! -d "$TMPPREFIX" ]]; then
            mkdir -p "$TMPPREFIX"
          fi
        '';

        initExtraFirst = ''
          # Shadow fortune command to prevent prezto's zlogin from showing it
          # (distracting on terminal open - only want it on logout)
          fortune() { : ; }
        '';

        initExtra = ''
          # Powerlevel10k instant prompt (must be near top)
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          # Homebrew
          if [[ -d /opt/homebrew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          fi

          # Powerlevel10k config
          source ${./p10k.zsh}

          # Custom functions
          c() { cd $PROJECTS/''${1:-.}; }
          _c() { _files -W $PROJECTS -/; }
          compdef _c c

          gf() {
            local branch=$1
            git checkout -b $branch origin/$branch
          }

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

          # Window title function
          title() {
            a=''${(V)1//\%/\%\%}
            a=$(print -Pn "%40>...>$a" | tr -d "\n")
            case $TERM in
              screen) print -Pn "\ek$a:$3\e\\" ;;
              xterm*|rxvt) print -Pn "\e]2;$2\a" ;;
            esac
          }

          # Key bindings
          bindkey '^[^[[D' backward-word
          bindkey '^[^[[C' forward-word
          bindkey '^[[5D' beginning-of-line
          bindkey '^[[5C' end-of-line
          bindkey '^[[3~' delete-char
          bindkey '^?' backward-delete-char

          # Completion settings
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
          zstyle ':completion:*' insert-tab pending
        '';

        logoutExtra = ''
          if [[ -t 0 || -t 1 ]]; then
            ${pkgs.fortune}/bin/fortune wisdom goedel tao platitudes ascii-art 2>/dev/null || \
            cat <<-EOF

          "To be calm is the highest achievement of the self."
            -- Zen proverb
          EOF
            print
          fi
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

      # Silver searcher ignore
      home.file.".agignore".text = ''
        node_modules
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
    "MQTT Explorer" = 1455214828;
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
    # "iina"
    "discord"
    "signal"
    # "utm"
    # "private-internet-access" # kinda broken
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
