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
      nixpkgs.go
      nixpkgs.yt-dlp
      nixpkgs.flyctl
      nixpkgs.beets-unstable
      #(nixpkgs.callPackage ./tidal-dl.nix {})
    ];

  # programs.tmux = {
  #   shell = "\${nixpkgs.zsh}/bin/zsh";
  # };

  # programs.zsh = {
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
  #   shellAliases = {
  #     vim = "nvim";
  #     view = "vim -R";
  #     nix-upgrade = "sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'";
  #     cmake = "cmake -DCMAKE_MAKE_PROGRAM=${nixpkgs.gnumake}/bin/make -DCMAKE_AR=${nixpkgs.darwin.cctools}/bin/ar -DCMAKE_RANLIB=${nixpkgs.darwin.cctools}/bin/ranlib -DGMP_INCLUDE_DIR=${nixpkgs.gmp.dev}/include/ -DGMP_LIBRARIES=${nixpkgs.gmp}/lib/libgmp.10.dylib";
  #     ar = "${nixpkgs.darwin.cctools}/bin/ar";
  #   };
  # };

  # programs.fzf = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };

  # programs.git = {
  #   package = nixpkgs.gitAndTools.gitFull;
  #   enable = true;
  #   userName = "Smaug123";
  #   userEmail = "patrick+github@patrickstevens.co.uk";
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
  # };

  # programs.neovim.enable = true;
  # programs.neovim.plugins = with nixpkgs.vimPlugins; [
  #   molokai
  #   tagbar
  #   {
  #     plugin = rust-vim;
  #     config = "let g:rustfmt_autosave = 1";
  #   }
  #   {
  #     plugin = LanguageClient-neovim;
  #     config = "let g:LanguageClient_serverCommands = { 'nix': ['rnix-lsp'] }";
  #   }
  #   {
  #     plugin = syntastic;
  #     config = ''let g:syntastic_rust_checkers = ['cargo']
# let g:syntastic_always_populate_loc_list = 1
# let g:syntastic_auto_loc_list = 1
# let g:syntastic_check_on_open = 1
# let g:syntastic_check_on_wq = 0'';
  #   }

  #   YouCompleteMe
  #   tagbar
  # ];
  # programs.neovim.viAlias = true;
  # programs.neovim.vimAlias = true;
  # programs.neovim.vimdiffAlias = true;
  # programs.neovim.withPython3 = true;

  #programs.neovim.extraConfig = builtins.readFile ./init.vim;

  #home.file.".ssh/config".source = ./ssh.config;
}
