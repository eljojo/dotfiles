-- Neovim-only configuration layer (terminal nvim; MacVim never reads this file).
-- Concatenated into programs.neovim.initLua AFTER the shared vimrc is sourced, so
-- anything here wins on neovim while MacVim stays on the classic vimscript config.

-- Treesitter highlighting.
-- nixpkgs ships the new nvim-treesitter rewrite, which removed the old
-- `require('nvim-treesitter.configs').setup{}` API; the correct enable is per-buffer
-- vim.treesitter.start(). Parsers are prebuilt by withAllGrammars (no :TSInstall, no
-- compiler). Markdown is intentionally left to vim-markdown so its conceal/folding
-- and the `,m` toggle behave exactly as before.
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'rust', 'go',
    'typescript', 'typescriptreact',
    'javascript', 'javascriptreact',
    'nix', 'ruby', 'lua', 'sh', 'bash',
  },
  callback = function() pcall(vim.treesitter.start) end,
})
