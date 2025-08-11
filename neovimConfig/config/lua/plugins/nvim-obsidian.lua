-- config/lua/plugins/nvim-obsidian.lua
-- Pure obsidian.nvim functionality configuration

require("obsidian").setup({
  -- Required: specify your vault(s)
  workspaces = {
    {
      name = "personal",
      path = vim.fn.expand("~/Documents/personalStuff"),
    },
    {
      name = "work", 
      path = vim.fn.expand("~/Documents/studyStuff"),
    },
  },

  -- Optional: log level
  log_level = vim.log.levels.INFO,

  -- Daily notes configuration
  daily_notes = {
    folder = "dailies",
    date_format = "%Y-%m-%d",
    alias_format = "%B %-d, %Y",
    template = nil,
  },

  -- Completion settings
  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },

  -- New note options
  new_notes_location = "notes_subdir",
  note_id_func = function(title)
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
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
    folder = "templates", -- Updated from 'subdir' to 'folder'
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

  -- Picker configuration
  picker = {
    name = "telescope.nvim",
    note_mappings = {
      new = "<C-x>",
      insert_link = "<C-l>",
    },
    tag_mappings = {
      tag_note = "<C-x>",
      insert_tag = "<C-l>",
    },
  },

  -- UI options - DISABLE to avoid conflict with markview
  ui = {
    enable = false, -- Using markview instead
  },

  -- Follow URL with system browser
  follow_url_func = function(url)
    vim.fn.jobstart({"xdg-open", url}) -- Linux
  end,

  -- Advanced URI options (updated syntax)
  open = {
    app_name = "obsidian",
    use_advanced_uri = true,
  },

  -- Use new command syntax (no legacy commands)
  legacy_commands = false, -- Changed to false

  -- Disable deprecated mappings
  mappings = {}, -- Empty table instead of deprecated mappings

  -- Finder options
  finder = "telescope.nvim",
  finder_mappings = {
    new = "<C-x>",
  },

  -- Disable some features if needed
  disable_frontmatter = false,
  
  -- YAML frontmatter options
  yaml_parser = "native",
}) -- <- Make sure this closing brace is here!

-- Custom keymaps for Obsidian commands (new command syntax)
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Manual keybindings for obsidian functionality (since mappings are deprecated)
-- These replace the old mappings config
map("n", "gf", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>Obsidian follow_link<cr>"
  else
    return "gf"
  end
end, { noremap = false, expr = true })

map("n", "<cr>", function()
  return require("obsidian").util.smart_action()
end, { buffer = true, expr = true })

map("n", "<leader>ch", function()
  return require("obsidian").util.toggle_checkbox()
end, { buffer = true })
