-- Neovide-specific configuration
-- Note: vimrc is loaded via programs.neovim.extraConfig in home-manager

if vim.g.neovide then
  -- Enable Cmd key
  vim.g.neovide_input_use_logo = true

  -- Disable cursor animation
  vim.g.neovide_cursor_animation_length = 0

  -- Cmd+S -> Save
  vim.keymap.set('n', '<D-s>', ':w<CR>')

  -- Cmd+T -> New tab
  vim.keymap.set('n', '<D-t>', ':tabnew<CR>')

  -- Cmd+W -> Close tab
  vim.keymap.set('n', '<D-w>', ':tabclose<CR>')

  -- Cmd+1..9 -> Go to tab N
  for i = 1, 9 do
    vim.keymap.set('n', '<D-' .. i .. '>', i .. 'gt')
  end

  -- Cmd+C -> Copy (visual mode)
  vim.keymap.set('v', '<D-c>', '"+y')

  -- Cmd+V -> Paste (all modes)
  vim.keymap.set({'n', 'v', 's', 'x', 'o', 'i', 'l', 'c', 't'}, '<D-v>', function()
    vim.api.nvim_paste(vim.fn.getreg('+'), true, -1)
  end, { noremap = true, silent = true })
end
