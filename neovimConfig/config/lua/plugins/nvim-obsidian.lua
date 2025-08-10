-- config/lua/plugins/nvim-obsidian.lua
require("obsidian").setup({
  -- Required: specify your vault(s)
  workspaces = {
    {
      name = "personal",
      path = "~/Obsidian/personalStuff",  -- Change this to your vault path
    },
    {
      name = "work",
      path = "~/Obsidian/studyStuff",      -- Optional: add multiple vaults
    },
  },


  -- Optional: log level
  log_level = vim.log.levels.INFO,

  -- Daily notes configuration
  daily_notes = {
    folder = "dailies",
    date_format = "%Y-%m-%d",
    alias_format = "%B %-d, %Y",
    template = nil,  -- Use a template file if you have one
  },

  -- Completion settings
  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },

  -- Mappings (set to false to disable, or remap)
  mappings = {
    -- "Obsidian follow"
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Toggle checkbox
    ["<leader>ch"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
    -- Smart action (follow link, toggle checkbox, etc.)
    ["<cr>"] = {
      action = function()
        return require("obsidian").util.smart_action()
      end,
      opts = { buffer = true, expr = true },
    },
  },

  -- New note options
  new_notes_location = "notes_subdir",
  note_id_func = function(title)
    -- Create note IDs from title, stripping spaces and special chars
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, use timestamp
      suffix = tostring(os.time())
    end
    return suffix
  end,

  -- Note frontmatter template
  note_frontmatter_func = function(note)
    local out = { id = note.id, aliases = note.aliases, tags = note.tags }
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end
    return out
  end,

  -- Templates
  templates = {
    subdir = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    substitutions = {},
  },

  -- Image handling
  attachments = {
    img_folder = "assets/imgs",
    img_text_func = function(client, path)
      path = client:vault_relative_path(path) or path
      return string.format("![%s](%s)", path.name, path)
    end,
  },

  -- Picker configuration (works with telescope, fzf-lua, etc.)
  picker = {
    name = "telescope.nvim",  -- Change to your preferred picker
    mappings = {
      new = "<C-x>",
      insert_link = "<C-l>",
    },
  },

  -- UI options - DISABLE to avoid conflict with render-markdown
  ui = {
    enable = false,  -- Disable obsidian UI to use render-markdown instead
  },

  -- Follow URL with system browser
  follow_url_func = function(url)
    vim.fn.jobstart({"xdg-open", url})  -- Linux
    -- vim.fn.jobstart({"open", url})     -- macOS
    -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
  end,

  -- Use advanced URI for Obsidian app (updated syntax)
  open = {
    app_name = "obsidian",
    use_advanced_uri = true,
  },

  -- Enable legacy commands to avoid deprecation warning (set to false when ready to migrate)
  legacy_commands = true,

  -- Finder options
  finder = "telescope.nvim",  -- or "fzf-lua"
  finder_mappings = {
    new = "<C-x>",
  },

  -- Disable some features if needed
  disable_frontmatter = false,
  
  -- YAML frontmatter options
  yaml_parser = "native",
})

-- Setup render-markdown for better Obsidian experience
require('render-markdown').setup({
  enabled = true,
  render_modes = { 'n', 'c', 't' },
  preset = 'obsidian',  -- Use obsidian preset for callouts
  file_types = { 'markdown' },
  
  -- LaTeX math rendering
  latex = {
    enabled = true,
    converter = 'latex2text',  -- Converts LaTeX to Unicode
    highlight = 'RenderMarkdownMath',
    position = 'above',  -- Render above the LaTeX block
    top_pad = 0,
    bottom_pad = 0,
  },
  
  -- Obsidian-style checkboxes
  checkbox = {
    enabled = true,
    unchecked = { icon = '󰄱 ', highlight = 'ObsidianTodo' },
    checked = { icon = '󰱒 ', highlight = 'ObsidianDone' },
    custom = {
      todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'ObsidianRightArrow' },
    },
  },
  
  -- Enhanced callouts for Obsidian
  callout = {
    note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'ObsidianRefText' },
    tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'ObsidianDone' },
    important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'ObsidianTag' },
    warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'ObsidianRightArrow' },
  },
  
  -- Better heading rendering
  heading = {
    enabled = true,
    position = 'overlay',
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    width = 'full',
  },
})

-- Custom keymaps for Obsidian commands
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Leader + o prefix for Obsidian commands
map("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian note" })
map("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian app" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })
map("n", "<leader>ot", "<cmd>ObsidianTemplate<cr>", { desc = "Insert template" })
map("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
map("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch" })
map("n", "<leader>ol", "<cmd>ObsidianLinks<cr>", { desc = "Show links" })
map("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Today's note" })
map("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday's note" })
map("n", "<leader>om", "<cmd>ObsidianTomorrow<cr>", { desc = "Tomorrow's note" })

-- Visual mode mappings
map("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Link selection" })
map("v", "<leader>oln", "<cmd>ObsidianLinkNew<cr>", { desc = "Link to new note" })
map("v", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", { desc = "Extract to new note" })

