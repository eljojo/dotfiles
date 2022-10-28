{ config, pkgs, lib, ... }:

let
in {
  imports = [ ./mac-defaults.nix ];

  users.users.jojo = {
    name = "jojo";
    home = "/Users/jojo";
  };
  services.redis.enable = true;
  services.redis.dataDir = "/Users/jojo/.local/share/redis/";

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_14;
  services.postgresql.dataDir = "/Users/jojo/.local/share/postgresql/data/";
  # create default user with `psql -U postgres` and `CREATE USER jojo SUPERUSER;`

  # launchd.user.agents.postgresql.serviceConfig = {
  #   StandardErrorPath = "/Users/jojo/.local/share/postgresql/postgres.error.log";
  #   StandardOutPath = "/Users/jojo/.local/share/postgresql/postgres.out.log";
  # };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.fzf
      pkgs.curl
      pkgs.wget
      pkgs.go
      pkgs.silver-searcher
      pkgs.git
    ];

  homebrew = {
    enable = true;
    masApps = {
      Tailscale = 1475387142;
      Transmit = 1436522307;
      "Home Assistant" = 1099568401;
      "Day One" = 1055511498;
      Telegram = 747648890;
      Tweetbot = 1384080005;
      "Microsoft Remote Desktop" = 1295203466;
      "Consent-O-Matic" = 1606897889;
      StopTheMadness = 1376402589;
      NotionWebClipper = 1559269364;
      TweaksForTwitter = 1567751529;
    };
    casks = [
      "macvim"
      "iterm2"
      "flycut"
      "syncthing"
      "iina"
      "skype"
      "notion"
      "discord"
      "signal"
      "utm"
    ];
  };

  environment.variables.EDITOR = "vim";

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
  # environment.darwinConfig = "$HOME/.dotfiles/nix/darwin-configuration.nix";

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
