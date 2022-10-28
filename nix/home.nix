{ nixpkgs, ... }:

let username = "jojo"; in

{
  imports = [  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  home.username = username; # username is a variable

  xdg.dataFile."postgresql/.keep".text = ""; # Create ~/.local/share/postgresql/
  xdg.dataFile."redis/.keep".text = ""; # Create ~/.local/share/redis/

  home.packages =
    [
      nixpkgs.iperf3
      nixpkgs.yt-dlp
      nixpkgs.flyctl
      nixpkgs.beets-unstable
      (nixpkgs.callPackage ./tidal-dl.nix {})
      nixpkgs.fortune
      nixpkgs.tree
      nixpkgs.git-lfs
      nixpkgs.htop
      # nixpkgs.darwin-zsh-completions
      nixpkgs.comma
      nixpkgs.vim
    ];

  programs.tmux = {
    enable = true;
    #shell = "\${nixpkgs.zsh}/bin/zsh";
  };

  programs.zsh = {
    enableSyntaxHighlighting = true;
  #   enable = true;
  #   autocd = true;
  #   enableAutosuggestions = true;
  #   enableCompletion = true;
  #   history = {
  #     expireDuplicatesFirst = true;
  #   };
  #   oh-my-zsh = {
  #     enable = true;
  #     plugins = [ "git" "macos" "dircycle" "timer" ];
  #     theme = "robbyrussell";
  #   };
  #   sessionVariables = {
  #     EDITOR = "vim";
  #     LC_ALL = "en_US.UTF-8";
  #     LC_CTYPE = "en_US.UTF-8";
  #     RUSTFLAGS = "-L ${nixpkgs.libiconv}/lib";
  #     RUST_BACKTRACE = "full";
  #   };
    shellAliases = {
      nix-upgrade = "sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  #programs.git = {
  #  package = nixpkgs.gitAndTools.gitFull;
  #  enable = true;
  #   userName = "";
  #   userEmail = "";
  #   aliases = {
  #     co = "checkout";
  #     st = "status";
  #   };
  #   extraConfig = {
  #     rerere = {
  #       enabled = true;
  #     };
  #     push = {
  #       default = "current";
  #     };
  #     pull = {
  #       rebase = false;
  #     };
  #     init = {
  #       defaultBranch = "main";
  #     };
  #     advice = {
  #       addIgnoredFile = false;
  #     };
  #     "filter \"lfs\"" = {
  #       clean = "${nixpkgs.git-lfs} clean -- %f";
  #       smudge = "${nixpkgs.git-lfs}/bin/git-lfs smudge --skip -- %f";
  #       process = "${nixpkgs.git-lfs}/bin/git-lfs filter-process";
  #       required = true;
  #     };
  #     pull = {
  #       twohead = "ort";
  #     };
  #   };
  #};

  #home.file.".ssh/config".source = ./ssh.config;
}
