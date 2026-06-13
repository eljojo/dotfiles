-- Invariant checks for the configured neovim, run by the flake `checks` against the
-- built package (the manual headless verifications, made automatic). A rust buffer
-- (full) or nix buffer (slim) is already open. Prints ALL_CHECKS_OK to stderr only if
-- everything passes. $NVIM_CHECK_SLIM=1 selects the slim (no copilot/node/fzf-lua/ibl)
-- expectations.
local ok = true
local function chk(cond, msg)
  if not cond then
    io.stderr:write('FAIL: ' .. msg .. '\n')
    ok = false
  end
end

local slim = vim.env.NVIM_CHECK_SLIM == '1'
local b = vim.api.nvim_get_current_buf()

-- Common to both builds: colorscheme, treesitter on the open buffer, NERDTree reveal,
-- and gc/gcc commenting.
chk(vim.g.colors_name == 'solarized', 'colorscheme is solarized')
chk(vim.o.termguicolors == true, 'termguicolors enabled')
chk(vim.treesitter.highlighter.active[b] ~= nil,
  'treesitter active on ' .. vim.bo[b].filetype)
chk(vim.fn.maparg(',n', 'n'):find('NERDTreeFind') ~= nil, ',n -> :NERDTreeFind')
chk(vim.fn.maparg('gcc', 'n') ~= '', 'gcc built-in commenting available')

if slim then
  -- Lean root build: fzf.vim :Files on <C-p>; deliberately NO fzf-lua/ibl/copilot/node.
  chk(vim.fn.maparg('<C-p>', 'n'):find('Files') ~= nil, 'slim: <C-p> -> :Files (fzf.vim)')
  chk(vim.fn.executable('fzf') == 1, 'slim: fzf on PATH for <C-p>')
  chk(vim.fn.exists(':FzfLua') == 0, 'slim: no fzf-lua')
  chk(package.loaded.ibl == nil, 'slim: no indent-blankline')
  chk(vim.fn.exists(':Copilot') == 0, 'slim: copilot absent')
  chk(vim.fn.executable('node') == 0, 'slim: node absent from PATH')
else
  -- Full Mac build: fzf-lua on <C-p>, indent-blankline, copilot.
  chk(vim.fn.maparg('<C-p>', 'n'):find('FzfLua') ~= nil, 'full: <C-p> -> fzf-lua files')
  chk(vim.fn.maparg(',f', 'n'):find('FzfLua') ~= nil, 'full: ,f -> live_grep')
  chk(package.loaded.ibl ~= nil, 'full: indent-blankline loaded')
  chk(vim.fn.exists(':Copilot') ~= 0, 'full: copilot present')
end

if ok then
  io.stderr:write('ALL_CHECKS_OK\n')
end
vim.cmd('qa!')
