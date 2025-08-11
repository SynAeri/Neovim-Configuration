-- config/lua/plugins/nvim-markview.lua
require('markview').setup({
  -- Hybrid mode - edit and preview simultaneously
  modes = { "n", "i", "no", "c" },
  hybrid_modes = { "i" },  -- Raw markdown in insert mode
  
  -- Split view for live preview
  split_view = {
    enable = true,
    position = "right",
  },
  
  -- Math rendering
  latex = {
    enable = true,
  },
  
  -- Obsidian-style elements
  checkboxes = {
    enable = true,
    checked = { text = "✓" },
    unchecked = { text = "○" },
  },
  
  -- Callouts (same as obsidian)
  block_quotes = {
    enable = true,
  },
})

-- Keybindings
vim.keymap.set("n", "<leader>mv", ":Markview Toggle<cr>", { desc = "Toggle markview" })
vim.keymap.set("n", "<leader>ms", ":Markview splitToggle<cr>", { desc = "Toggle split view" })
vim.keymap.set("n", "<leader>mh", ":Markview hybridToggle<cr>", { desc = "Toggle hybrid mode" })
