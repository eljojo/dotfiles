-- Slim neovim Lua layer for root on servers ("a step up above vanilla, not an IDE").
-- Solarized dark + treesitter for the file types root actually edits. Keymaps come
-- from the shared vimrc (<C-p> -> :Files via fzf.vim, <C-n>/,n -> NERDTree); gc/gcc is
-- neovim's built-in commenting. No fzf-lua / indent-blankline / copilot here, so nothing
-- errors when those (intentionally absent) plugins aren't installed.

vim.opt.termguicolors = true
vim.opt.background = 'dark'
pcall(vim.cmd.colorscheme, 'solarized')

-- Treesitter only for the languages root touches (parsers load lazily per buffer).
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'nix', 'sh', 'bash', 'yaml', 'lua', 'json', 'markdown' },
  callback = function() pcall(vim.treesitter.start) end,
})
