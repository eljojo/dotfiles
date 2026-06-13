# Flake checks: build each configured neovim and run ./check.lua against it headless,
# asserting the same invariants we'd otherwise verify by hand (colorscheme, treesitter,
# keymaps, and that the slim build really has no copilot/node). `nix flake check` runs
# these; a regression fails the build instead of silently shipping.
{
  pkgs,
  lib ? pkgs.lib,
}:
let
  nvim = import ./neovim.nix { inherit pkgs lib; };

  mkCheck =
    name: package: slim:
    pkgs.runCommand "check-${name}" { } ''
      export HOME=$(mktemp -d)
      mkdir -p "$HOME/.vim/undofiles" "$HOME/.vim/backup"
      printf 'fn main() {\n    let x: i32 = 1;\n    println!("{}", x);\n}\n' > "$HOME/t.rs"
      ${lib.optionalString slim ''export NVIM_CHECK_SLIM=1''}
      ${package}/bin/nvim --headless \
        "+edit $HOME/t.rs" \
        "+luafile ${./check.lua}" 2> "$HOME/log" || true
      if grep -q ALL_CHECKS_OK "$HOME/log"; then
        echo "PASS: ${name}"
        touch $out
      else
        echo "FAIL: ${name}"
        cat "$HOME/log"
        exit 1
      fi
    '';
in
{
  neovim-full = mkCheck "neovim-full" nvim.package false;
  neovim-slim = mkCheck "neovim-slim" nvim.slimPackage true;
}
