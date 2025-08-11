vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true


-- Keybinds

-- Method to set mapping quicker
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- ============================================================================
-- OBSIDIAN.NVIM KEYBINDINGS
-- ============================================================================
-- Note Management
map("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Obsidian note" })
map("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Open in Obsidian app" })
map("n", "<leader>oq", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick switch notes" })
map("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
map("n", "<leader>or", "<cmd>Obsidian rename<cr>", { desc = "Rename note" })

-- Daily Notes
map("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "Today's note" })
map("n", "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Yesterday's note" })
map("n", "<leader>om", "<cmd>Obsidian tomorrow<cr>", { desc = "Tomorrow's note" })
map("n", "<leader>oda", "<cmd>Obsidian dailies<cr>", { desc = "Daily notes picker" })

-- Links and References
map("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Show all links" })
map("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Show backlinks" })
map("n", "<leader>of", "<cmd>Obsidian follow_link<cr>", { desc = "Follow link" })

-- Templates and Content
map("n", "<leader>ot", "<cmd>Obsidian template<cr>", { desc = "Insert template" })
map("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Paste image" })
map("n", "<leader>otoc", "<cmd>Obsidian toc<cr>", { desc = "Table of contents" })

-- Tags and Organization
map("n", "<leader>ota", "<cmd>Obsidian tags<cr>", { desc = "Search tags" })
map("n", "<leader>ow", "<cmd>Obsidian workspace<cr>", { desc = "Switch workspace" })

-- Checkboxes and Interactive Elements
map("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Toggle checkbox" })

-- Visual Mode Mappings
map("v", "<leader>ol", "<cmd>Obsidian link<cr>", { desc = "Link selection" })
map("v", "<leader>oln", "<cmd>Obsidian link_new<cr>", { desc = "Link to new note" })
map("v", "<leader>oe", "<cmd>Obsidian extract_note<cr>", { desc = "Extract to new note" })

-- ============================================================================
-- RENDER-MARKDOWN.NVIM COMMANDS
-- ============================================================================

-- ============================================================================
-- NEO-TREE KEYBINDS
-- ============================================================================

map("n", "<leader>tr", ":Neotree toggle right<CR>", { noremap = true, silent = true, desc = "Toggle Neo-tree" })


-- ============================================================================
-- GENERAL STUFF
-- ============================================================================

map ("n", "<leader>fw", ":Telescope live_grep<cr>", {desc = "Does a live grep search"}) 
