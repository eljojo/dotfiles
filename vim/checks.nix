# Flake checks: build each configured neovim and run ./check.lua against it headless,
# asserting the same invariants we'd otherwise verify by hand (colorscheme, treesitter,
# keymaps, and that the slim build really is lean — fzf.vim on <C-p>, no fzf-lua/copilot/
# node). `nix flake check` runs these; a regression fails the build instead of shipping.
{
  pkgs,
  lib ? pkgs.lib,
}:
let
  nvim = import ./neovim.nix { inherit pkgs lib; };

  mkCheck =
    name: package:
    {
      slim,
      testBasename,
      testContent,
    }:
    let
      testFile = pkgs.writeText testBasename testContent;
    in
    pkgs.runCommand "check-${name}" { } ''
      export HOME=$(mktemp -d)
      mkdir -p "$HOME/.vim/undofiles" "$HOME/.vim/backup"
      cp ${testFile} "$HOME/${testBasename}"
      ${lib.optionalString slim ''export NVIM_CHECK_SLIM=1''}
      ${package}/bin/nvim --headless \
        "+edit $HOME/${testBasename}" \
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
  neovim-full = mkCheck "neovim-full" nvim.package {
    slim = false;
    testBasename = "t.rs";
    testContent = "fn main() {\n    let x: i32 = 1;\n    println!(\"{}\", x);\n}\n";
  };
  neovim-slim = mkCheck "neovim-slim" nvim.slimPackage {
    slim = true;
    testBasename = "t.nix";
    testContent = "{ a = 1; b = [ 1 2 3 ]; }\n";
  };
}
