[
  (self: super: {
    # https://github.com/NixOS/nixpkgs/issues/153304
    alacritty = super.alacritty.overrideAttrs (
      o: rec {
        doCheck = false;
      }
    );
    beets-unstable = super.beets-unstable.override({
      pluginOverrides = {
        copyartifacts = { enable = true; propagatedBuildInputs = [ super.beetsPackages.copyartifacts ]; };
        limit = { builtin = true; };
      };
    });
    aacgain = super.callPackage ./aacgain.nix {};
    keyfinder-cli = super.keyfinder-cli.overrideAttrs (
      _: { meta.platforms = super.lib.platforms.darwin ++ super.lib.platforms.linux; }
    );
  })
]
