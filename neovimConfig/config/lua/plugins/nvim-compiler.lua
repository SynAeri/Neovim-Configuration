-- config/lua/compiler.lua
require('compiler').setup()


-- Keybinds
vim.keymap.set('n', '<leader>cc', '<cmd>CompilerOpen<cr>', { desc = "Open compiler" })
vim.keymap.set('n', '<leader>cr', '<cmd>CompilerRedo<cr>', { desc = "Redo last compilation" })
vim.keymap.set('n', '<leader>ct', '<cmd>CompilerToggleResults<cr>', { desc = "Toggle compiler results" })

