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

-- Colorscheme: solarized dark, neovim only (MacVim sets this in gvimrc). termguicolors
-- so solarized's 24-bit palette renders accurately in the terminal.
vim.opt.termguicolors = true
vim.opt.background = 'dark'
pcall(vim.cmd.colorscheme, 'solarized')

-- Indent guides (indent-blankline; replaces indentLine on nvim).
require('ibl').setup({})

-- Fuzzy finder (fzf-lua). <C-p> opens files (same key as before); ,f live-greps.
-- fzf.vim stays loaded, so :Files / :Ag remain as a fallback.
require('fzf-lua').setup({})
local map = vim.keymap.set
map('n', '<C-p>', '<cmd>FzfLua files<cr>', { silent = true })
map('n', '<leader>f', '<cmd>FzfLua live_grep<cr>', { silent = true })
