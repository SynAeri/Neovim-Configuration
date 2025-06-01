require('overseer').setup({
  templates = { "builtin" },
  task_list = {
    direction = "bottom",
    min_height = 25,
    max_height = 25,
  },

})

-- Keymaps
vim.keymap.set('n', '<leader>oo', '<cmd>OverseerToggle<cr>')
vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>')
vim.keymap.set('n', '<leader>oc', '<cmd>OverseerRunCmd<cr>')
vim.keymap.set('n', '<leader>ol', '<cmd>OverseerLoadBundle<cr>')


