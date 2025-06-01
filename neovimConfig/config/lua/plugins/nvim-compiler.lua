-- config/lua/compiler.lua
require('compiler').setup()

-- Keymaps
vim.keymap.set('n', '<F6>', '<cmd>CompilerOpen<cr>', { desc = "Open compiler" })
vim.keymap.set('n', '<F7>', '<cmd>CompilerRedo<cr>', { desc = "Redo last action" })
vim.keymap.set('n', '<S-F6>', '<cmd>CompilerToggleResults<cr>', { desc = "Toggle results" })
