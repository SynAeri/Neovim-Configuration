-- config/lua/plugins/nvim-peek.lua
require('peek').setup({
  auto_load = true,
  close_on_bdelete = true,
  syntax = true,
  theme = 'dark',
  update_on_change = true,
  app = 'webview',
  filetype = { 'markdown' },
  throttle_at = 200000,
  throttle_time = 'auto',
})

-- Create the commands manually
vim.api.nvim_create_user_command('PeekOpen', function()
  require('peek').open()
end, { desc = "Open markdown preview" })

vim.api.nvim_create_user_command('PeekClose', function()
  require('peek').close()
end, { desc = "Close markdown preview" })

vim.api.nvim_create_user_command('PeekToggle', function()
  local peek = require('peek')
  if peek.is_open() then
    peek.close()
  else
    peek.open()
  end
end, { desc = "Toggle markdown preview" })

-- Keybindings
vim.keymap.set("n", "<leader>po", function() require('peek').open() end, { desc = "Open markdown preview" })
vim.keymap.set("n", "<leader>pc", function() require('peek').close() end, { desc = "Close markdown preview" })
vim.keymap.set("n", "<leader>pt", function()
  local peek = require('peek')
  if peek.is_open() then
    peek.close()
  else
    peek.open()
  end
end, { desc = "Toggle markdown preview" })
