# Shared home-manager config for all machines (macOS + NixOS)
# Machine-specific config should extend this
{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "José Albornoz";
        email = "jojo@eljojo.net";
      };

      aliases = {
        co = "checkout";
        count = "shortlog -sn";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
      };

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

    # Nix
    nix-cleanup = "nix-collect-garbage -d";
  };

  home.sessionVariables = {
    GOPATH = "$HOME/.go";
    PROJECTS = "$HOME/code";
    VISUAL = "vim";
    PAGER = "less";
    LESS = "-F -g -i -M -R -S -w -X -z-4";
  };

  home.sessionPath = [
    "$HOME/.go/bin"
    "$HOME/.bin"
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

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Shadow fortune command to prevent prezto's zlogin from showing it
        # (distracting on terminal open - only want it on logout)
        fortune() { : ; }
      '')
      ''
        # Powerlevel10k instant prompt (must be near top)
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Powerlevel10k config
        [ -f ~/.p10k.zsh ] && source ~/.p10k.zsh

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
              *.gz)      gunzip $1 ;;
              *.tar)     tar -xvf $1 ;;
              *.tbz2)    tar -jxvf $1 ;;
              *.tgz)     tar -zxvf $1 ;;
              *.zip|*.ZIP) unzip $1 ;;
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
      ''
    ];

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

  # p10k config file
  home.file.".p10k.zsh".source = ../config/p10k.zsh;

  # Silver searcher ignore
  home.file.".agignore".text = ''
    node_modules
  '';
}
