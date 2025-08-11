-- config/lua/plugins/nvim-markview.lua
-- Dedicated configuration for markview.nvim

require('markview').setup({
  -- Basic settings
  enabled = true,
  
  -- Preview settings (updated syntax)
  preview = {
    modes = { 'n', 'c', 't' },        -- Modes to show rendered view
    hybrid_modes = { 'i' },           -- Modes to show hybrid (raw + rendered)
  },
  
  -- File types to render
  filetypes = { 'markdown' },
  
  -- LaTeX math rendering
  latex = {
    enable = true,
  },
  
  -- Enhanced checkboxes
  checkboxes = {
    enable = true,
    checked = { text = "✓", hl = "MarkviewCheckboxChecked" },
    unchecked = { text = "○", hl = "MarkviewCheckboxUnchecked" },
    custom = {
      pending = { text = "◐", hl = "MarkviewCheckboxPending" },
      progress = { text = "◑", hl = "MarkviewCheckboxProgress" },
    },
  },
  
  -- Enhanced headings
  headings = {
    enable = true,
    shift_width = 0,
    heading_1 = {
      style = "icon",
      icon = "󰲡 ",
      hl = "MarkviewHeading1",
    },
    heading_2 = {
      style = "icon", 
      icon = "󰲣 ",
      hl = "MarkviewHeading2",
    },
    heading_3 = {
      style = "icon",
      icon = "󰲥 ",
      hl = "MarkviewHeading3",
    },
    heading_4 = {
      style = "icon",
      icon = "󰲧 ",
      hl = "MarkviewHeading4",
    },
    heading_5 = {
      style = "icon",
      icon = "󰲩 ",
      hl = "MarkviewHeading5",
    },
    heading_6 = {
      style = "icon",
      icon = "󰲫 ",
      hl = "MarkviewHeading6",
    },
  },
  
  -- Code blocks
  code_blocks = {
    enable = true,
    style = "language",
    position = "overlay",
    min_width = 60,
    pad_amount = 2,
  },
  
  -- Inline code
  inline_codes = {
    enable = true,
    corner_left = "",
    corner_right = "",
    padding_left = " ",
    padding_right = " ",
  },
  
  -- Block quotes and callouts
  block_quotes = {
    enable = true,
    default = {
      border_left = "▋",
      hl = "MarkviewBlockQuoteDefault",
    },
    callouts = {
      {
        match_string = "NOTE",
        callout_preview = "󰋽 Note",
        callout_preview_hl = "MarkviewBlockQuoteNote",
      },
      {
        match_string = "TIP", 
        callout_preview = "󰌶 Tip",
        callout_preview_hl = "MarkviewBlockQuoteOk",
      },
      {
        match_string = "IMPORTANT",
        callout_preview = "󰅾 Important", 
        callout_preview_hl = "MarkviewBlockQuoteSpecial",
      },
      {
        match_string = "WARNING",
        callout_preview = "󰀪 Warning",
        callout_preview_hl = "MarkviewBlockQuoteWarn",
      },
    },
  },
  
  -- Tables
  tables = {
    enable = true,
    use_virt_lines = true,
    text = {
      "┌", "┬", "┐",
      "├", "┼", "┤", 
      "└", "┴", "┘",
      "│", "─",
    },
  },
  
  -- List items
  list_items = {
    enable = true,
    shift_width = 2,
    indent_size = 2,
    marker_minus = {
      text = "●",
      hl = "MarkviewListItemMinus",
    },
    marker_plus = {
      text = "○",
      hl = "MarkviewListItemPlus", 
    },
    marker_star = {
      text = "◆",
      hl = "MarkviewListItemStar",
    },
  },
  
  -- Links
  links = {
    enable = true,
    hyperlinks = {
      icon = "󰌹 ",
      hl = "MarkviewHyperlink",
    },
    images = {
      icon = "󰥶 ",
      hl = "MarkviewImage",
    },
    emails = {
      icon = "󰀓 ",
      hl = "MarkviewEmail",
    },
  },
})

-- Keybindings for markview
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Markview control
map("n", "<leader>mv", "<cmd>Markview Toggle<cr>", { desc = "Toggle markview" })
map("n", "<leader>me", "<cmd>Markview Enable<cr>", { desc = "Enable markview" })
map("n", "<leader>md", "<cmd>Markview Disable<cr>", { desc = "Disable markview" })

-- Hybrid mode control  
map("n", "<leader>mh", "<cmd>Markview hybridToggle<cr>", { desc = "Toggle hybrid mode" })
map("n", "<leader>mhe", "<cmd>Markview hybridEnable<cr>", { desc = "Enable hybrid mode" })
map("n", "<leader>mhd", "<cmd>Markview hybridDisable<cr>", { desc = "Disable hybrid mode" })

-- Split view for live preview
map("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", { desc = "Toggle split view" })
map("n", "<leader>mso", "<cmd>Markview splitOpen<cr>", { desc = "Open split view" })
map("n", "<leader>msc", "<cmd>Markview splitClose<cr>", { desc = "Close split view" })

-- Render control
map("n", "<leader>mr", "<cmd>Markview render<cr>", { desc = "Render current buffer" })
map("n", "<leader>mc", "<cmd>Markview clear<cr>", { desc = "Clear current buffer" })
