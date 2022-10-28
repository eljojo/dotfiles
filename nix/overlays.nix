[
  (self: super: {
    # https://github.com/NixOS/nixpkgs/issues/153304
    alacritty = super.alacritty.overrideAttrs (
      o: rec {
        doCheck = false;
      }
    );
    aacgain = super.callPackage ./aacgain.nix {};
    keyfinder-cli = super.keyfinder-cli.overrideAttrs (
      _: { meta.platforms = super.lib.platforms.darwin ++ super.lib.platforms.linux; }
    );
  })
]
