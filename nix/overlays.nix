[
  (self: super: {
    # https://github.com/NixOS/nixpkgs/issues/153304
    alacritty = super.alacritty.overrideAttrs (
      o: rec {
        doCheck = false;
      }
    );
  })
]
