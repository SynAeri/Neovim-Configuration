-- config/lua/plugins/nvim-obsidian.lua
-- Pure obsidian.nvim functionality configuration

require("obsidian").setup({
  -- Required: specify your vault(s)
  workspaces = {
    {
      name = "all",
      path = vim.fn.expand("~/Obsidian/allStuff"),
    }
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
  legacy_commands = false,

  -- Remove mappings completely (deprecated)
  -- mappings = {}, -- Remove this line entirely

  -- Finder options
  finder = "telescope.nvim",
  finder_mappings = {
    new = "<C-x>",
  },

  -- Disable some features if needed
  disable_frontmatter = false,
  
  -- YAML frontmatter options
  yaml_parser = "native",
})
