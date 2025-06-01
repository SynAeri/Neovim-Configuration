-- config/lua/overseer.lua
require('overseer').setup({
  templates = { "builtin" },  -- Load built-in templates
  task_list = {
    direction = "bottom",
    min_height = 25,
    max_height = 25,
  },
})

-- Keymaps
vim.keymap.set('n', '<leader>oo', '<cmd>OverseerToggle<cr>', { desc = "Toggle Overseer" })
vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = "Run task" })
vim.keymap.set('n', '<leader>oc', '<cmd>OverseerRunCmd<cr>', { desc = "Run shell command" })
vim.keymap.set('n', '<leader>ol', '<cmd>OverseerLoadBundle<cr>', { desc = "Load task bundle" })
