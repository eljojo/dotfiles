-- Invariant checks for the configured neovim, run by the flake `checks` against the
-- built package (the manual headless verifications, made automatic). Run with a rust
-- buffer already open. Prints ALL_CHECKS_OK to stderr only if everything passes.
-- Set $NVIM_CHECK_SLIM=1 to assert the slim (no copilot/node) variant.
local ok = true
local function chk(cond, msg)
  if not cond then
    io.stderr:write('FAIL: ' .. msg .. '\n')
    ok = false
  end
end

local b = vim.api.nvim_get_current_buf()

-- Editor experience (must match the Mac terminal nvim).
chk(vim.bo[b].filetype == 'rust', 'rust filetype detected')
chk(vim.g.colors_name == 'solarized', 'colorscheme is solarized')
chk(vim.o.termguicolors == true, 'termguicolors enabled')
chk(vim.treesitter.highlighter.active[b] ~= nil, 'treesitter highlighting active on rust')
chk(package.loaded.ibl ~= nil, 'indent-blankline (ibl) loaded')
chk(vim.fn.exists(':FzfLua') == 2, 'fzf-lua command available')

-- Keybinding parity (mapleader is "," from the shared vimrc).
chk(vim.fn.maparg('<C-p>', 'n'):find('FzfLua') ~= nil, '<C-p> -> fzf-lua files')
chk(vim.fn.maparg(',n', 'n'):find('NERDTreeFind') ~= nil, ',n -> :NERDTreeFind')
chk(vim.fn.maparg(',f', 'n'):find('FzfLua') ~= nil, ',f -> fzf-lua live_grep')
chk(vim.fn.maparg('gcc', 'n') ~= '', 'gcc built-in commenting available')

-- Variant-specific.
if vim.env.NVIM_CHECK_SLIM == '1' then
  chk(vim.fn.exists(':Copilot') == 0, 'slim: copilot absent')
  chk(vim.fn.executable('node') == 0, 'slim: node absent from PATH')
else
  chk(vim.fn.exists(':Copilot') ~= 0, 'full: copilot present')
end

if ok then
  io.stderr:write('ALL_CHECKS_OK\n')
end
vim.cmd('qa!')
