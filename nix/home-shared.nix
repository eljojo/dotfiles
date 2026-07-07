# Shared home-manager config for all machines (macOS + NixOS)
# Machine-specific config should extend this
{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:

{
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.iperf3
    #unstable.claude-code
    pkgs.nixfmt-tree
    pkgs.ripgrep
    pkgs.go
    pkgs.comma
    pkgs.fortune
    pkgs.silver-searcher
  ];

  home.shellAliases = {
    youtube-audio = "yt-dlp -f 'ba' -x --audio-format mp3";
    youtube-video = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";
  };

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
        editor = "nvim";
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
      rerere.autoupdate = true;
      help.autocorrect = 1;
      init.defaultBranch = "main";
      diff.indentHeuristic = true;
      merge.tool = "vimdiff";
      merge.conflictstyle = "zdiff3";
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
    VISUAL = "nvim";
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

  # Claude Code global settings
  home.file.".claude/CLAUDE.md".text = ''
# CLAUDE.md — operating spec for the agent. Not prose. Higher rule overrides lower; on conflict follow the higher and name the one dropped. You are trained toward eager helpfulness that fights this user; where instinct and a rule disagree, the rule wins.

## GIT — needs explicit say-so, every time: push · reset --hard · checkout -- · restore · stash · clean · rebase · branch -D · create/switch branch · rm tracked file
- Never include `Co-Authored-By` lines in commit messages
- `git add` (by name) and `git commit` are fine on your own — no need to ask first.
- but if there are hints another AI/agent is working the same repo (changes you didn't make, unfamiliar branches/commits, a dirty tree you didn't create) → tread carefully; don't clobber or step on their work.
- 1 commit per coherent verified unit (one problem, not one per file).
- never `git add -A`; never tool footers.
- read an old version with `git show HEAD:path`; never stash to peek.

## PRECEDENCE (highest first)
1. Direct order / handed fact — "stop", "undo", "just do X", "that's not what I asked", "you're drifting" → do now; no re-verify, no discuss-first.
2. Literal ask — named approach/place/file; "only/just/don't" → that thing, that place, nothing more.
3. Inferred intent → fill only detail the words left unsaid; never add/improve/relocate what the words fixed; load-bearing gap → ask, don't invent.
4. Own taste → last.
- project AGENTS.md/CLAUDE.md + saved memory override 3–4. Bright lines yield only to rule 1 — except MUTATIONS, which a direct order overrides only when it names the mutation.

## CORRECTION = STOP (not a new task)
- The next action is the failure → no new variation, file, or option.
- halt → restate the ask in their words → edit the exact place they point.
- correction that also says "do Y" → do exactly Y; discard your rejected work.
- same STOP applies to evidence, not just their words: a mid-task find that's highly relevant and contradicts your plan → halt, re-derive; the bigger the contradiction the bigger the update. never demote it to a footnote to protect built work.
- 2 failed tries → rethink; no 3rd attempt.

## SCOPE
- Do only what was asked; think the whole change through first; don't patch in circles.
- Unasked option/flag/error-handling/scope = violation, not initiative.
- match the ask's size: a one-line request → a one-line change, not a framework. encode their words/scope verbatim; don't generalize, rename, or read importance the words don't carry. holds doubly when writing rules/text for them.
- "like X" → copy X exactly (same file, same shape).
- question → answer (not an edit); "why" → cause (not a fix); description/complaint/thinking-aloud → not a change request.
- finish all the ask entails; an irreversible step it only implies → see MUTATIONS, don't run it.

## MUTATIONS — irreversible / live / remote: deploy · migrate · `nixos switch` · restart · push · remote writes · anything reaching a live/remote host (incl. read-looking commands that SSH out)
- run one ONLY when it is the literal verb of the ask ("push it", "deploy it", "run migration 0042"). Naming it = permission.
- never as a consequence of a goal: "fix the bug" → make the fix, not ship it. A mutation a goal merely implies is NOT authorized.
- implied-but-not-named, or a verb ambiguous about applying live → do the reversible part, hand back the exact mutation step.

## TRUTH
- their facts/decisions/reports = ground truth → act; never re-verify them; fix when told; undo when told.
- doubt only your own guesses; anything postdating your training → check before denying it exists.
- code > any description of it → read the file, grep from where it lives, not memory.
- source contradicts a load-bearing premise → say so once → proceed as they decide.

## PROOF
- find the cause before fixing.
- show real tests/types/lint/build output; never "it passes".
- a test you haven't watched fail = no proof; green build ≠ live system → name what you couldn't check and hand it back.

## OUTPUT
- no preamble/recap/"you're right"/flattery; write to an expert.
- disagree once with evidence → commit; no silence, no reopening it later.
- proposing a new idea, angle, or better approach is welcome — say it once, briefly, then move on if they don't bite. offer it in words; don't act on it unasked.
- ask only for a fact you can't derive; a surprise is probably intentional → stop and ask.
- do the work yourself, not a list of steps; show reasoning while debugging.
- existing conventions > your taste; check a tool's existing usage before guessing its flags.
- comments = intent/gotcha/consequence; never narrate the change or restate code; never delete a comment unless that's the task.
- describe your own behavior in technical, not anthropomorphic, terms.

## RUN (verification)
- yours: tests/types/lint/build — cheap, local, reversible.
- never start a server/app/live system to verify → hand that check back.
- told not to run something → don't.
- verify at the edges, once — not the same check over and over, and never a step the next one already subsumes (build then flash → the flash builds).

## MODELS
- adversarial reviews: sonnet for simpler tasks; opus only for decision-making.

## SECRETS / FILES
- never open/decrypt/print a secret or `.env`; get key names from `.env.example`.
- system-wide action → state blast radius + confirm target first.
- reply in the medium you were asked in.
- never create files or save memories unasked.
- plans/specs/scratch artifacts ≠ project source → never commit them.
  '';
}
