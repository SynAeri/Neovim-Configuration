-- config/lua/plugins/markdown-preview.lua

-- Markdown preview settings
vim.g.mkdp_auto_start = 0                    -- Don't auto-start preview
vim.g.mkdp_auto_close = 1                    -- Auto-close when switching buffers
vim.g.mkdp_refresh_slow = 0                  -- Real-time refresh
vim.g.mkdp_command_for_global = 0            -- Available for all file types? 0=no
vim.g.mkdp_open_to_the_world = 0             -- Make server available externally? 0=no
vim.g.mkdp_open_ip = ""                      -- Custom IP (empty = localhost)
vim.g.mkdp_port = ""                         -- Custom port (empty = random)
vim.g.mkdp_browser = ""                      -- Custom browser (empty = default)
vim.g.mkdp_echo_preview_url = 0              -- Echo preview URL in command line
vim.g.mkdp_browserfunc = ""                  -- Custom browser function

-- Preview options
vim.g.mkdp_preview_options = {
  mkit = {},
  katex = {},                                -- Math rendering
  uml = {},                                  -- UML diagrams  
  maid = {},                                 -- Mermaid diagrams
  disable_sync_scroll = 0,                   -- Enable sync scroll
  sync_scroll_type = "middle",               -- Sync scroll position
  hide_yaml_meta = 1,                        -- Hide YAML frontmatter
  sequence_diagrams = {},
  flowchart_diagrams = {},
  content_editable = false,                  -- Make preview read-only
  disable_filename = 0,                      -- Show filename in preview
  toc = {}                                   -- Table of contents
}

-- Styling
vim.g.mkdp_markdown_css = ""                 -- Custom CSS file path
vim.g.mkdp_highlight_css = ""                -- Custom highlight CSS  
vim.g.mkdp_page_title = "「${name}」"         -- Page title template
vim.g.mkdp_filetypes = {"markdown"}          -- Recognized filetypes
vim.g.mkdp_theme = "dark"                    -- Theme: dark or light (matches your setup)

-- Keymaps for markdown preview
vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreview<CR>", 
  { noremap = true, silent = true, desc = "Markdown Preview" })
vim.api.nvim_set_keymap("n", "<leader>ms", ":MarkdownPreviewStop<CR>", 
  { noremap = true, silent = true, desc = "Stop Markdown Preview" })
vim.api.nvim_set_keymap("n", "<leader>mt", ":MarkdownPreviewToggle<CR>", 
  { noremap = true, silent = true, desc = "Toggle Markdown Preview" })

-- Auto-commands for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Additional markdown-specific settings
    vim.opt_local.wrap = true          -- Enable line wrapping
    vim.opt_local.linebreak = true     -- Break lines at word boundaries
    vim.opt_local.conceallevel = 2     -- Enable concealing for better readability
    
    -- Buffer-local keymaps (only active in markdown files)
    vim.keymap.set("n", "<leader>mv", ":MarkdownPreview<CR>", 
      { buffer = true, desc = "Preview Markdown" })
  end,
})
