-- config/lua/chadrc.lua
local M = {}

-- Function to load saved theme (MISSING FUNCTION)
local function load_saved_theme()
  local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
  if vim.fn.filereadable(theme_file) == 1 then
    local ok, theme_config = pcall(dofile, theme_file)
    if ok and theme_config and theme_config.theme then
      print("Loading saved theme: " .. theme_config.theme)
      return theme_config.theme
    end
  end
  print("Using default theme: onedark")
  return "onedark" -- default fallback
end

-- Function to save theme persistently
local function save_theme_to_file(theme_name)
  local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
  local content = string.format('return { theme = "%s" }', theme_name)
  
  local file = io.open(theme_file, "w")
  if file then
    file:write(content)
    file:close()
    vim.notify("Theme saved: " .. theme_name, vim.log.levels.INFO)
    return true
  end
  return false
end

-- Create a custom theme picker command that saves themes
vim.api.nvim_create_user_command("ThemePicker", function()
  -- First, override the reload_theme function to capture theme changes
  local ok, base46 = pcall(require, "base46")
  if ok and base46.reload_theme then
    local original_reload = base46.reload_theme
    base46.reload_theme = function(theme_name)
      original_reload(theme_name)
      -- Save the theme when it changes
      save_theme_to_file(theme_name)
    end
  end
  
  -- Open the theme picker
  require("nvchad.themes").open()
end, { desc = "Open theme picker with auto-save" })

-- Alternative: Create a telescope-based theme picker that saves
vim.api.nvim_create_user_command("TelescopeThemes", function()
  -- Try to use telescope themes if available
  local ok = pcall(vim.cmd, "Telescope themes")
  if not ok then
    vim.notify("Telescope themes not available, using modern picker", vim.log.levels.WARN) 
    vim.cmd("ThemePicker")
  end
end, { desc = "Open telescope theme picker" })

-- Hook into base46.reload_theme globally to catch any theme changes
vim.defer_fn(function()
  local ok, base46 = pcall(require, "base46")
  if ok and base46.reload_theme then
    local original_reload = base46.reload_theme
    base46.reload_theme = function(theme_name)
      original_reload(theme_name)
      save_theme_to_file(theme_name)
    end
    print("✅ Theme auto-save hook installed")
  else
    print("❌ Failed to install theme hook")
  end
end, 1000)

-- Manual save command
vim.api.nvim_create_user_command("SaveTheme", function(opts)
  local theme_name = opts.args
  if not theme_name or theme_name == "" then
    -- Try to detect current theme from various sources
    theme_name = vim.g.nvchad_theme or vim.g.colors_name or "onedark"
  end
  save_theme_to_file(theme_name)
end, { nargs = "?", desc = "Manually save current theme" })

-- Base46 configurations - NOW USES THE CORRECT FUNCTION
M.base46 = {
  theme = load_saved_theme(), -- Load saved theme on startup
  hl_add = {},
  hl_override = {},
  integrations = {},
  changed_themes = {},
  transparency = false,
  theme_toggle = { "onedark", "one_light" },
}
-- UI configurations
M.ui = {
  -- Statusline configuration
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    separator_style = "default", -- default/round/block/arrow
  },
  -- Tabufline (bufferline + tabline) configuration
  tabufline = {
    enabled = true,
    lazyload = false,
  },
  -- CMP configuration
  cmp = {
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },
  -- Telescope style
  telescope = { style = "borderless" }, -- borderless / bordered
}

-- NvDash configuration
M.nvdash = {
  load_on_startup = false,
  header = {
    "                            ",
    "⠤⠤⠤⠤⠤⠤⢤⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⠶⠶⠶⠦⠤⠤⠤⠤⠤⢤⣤⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⢀⠄⢂⣠⣭⣭⣕⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠀⠀⠀⠤⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉",
    "⠀⠀⢀⠜⣳⣾⡿⠛⣿⣿⣿⣦⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣍⣀⣦⠦⠄⣀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠠⣄⣽⣿⠋⠀⡰⢿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡿⠛⠛⡿⠿⣿⣿⣿⣿⣿⣿⣷⣶⣿⣁⣂⣤⡄⠀⠀⠀⠀⠀⠀",
    "⢳⣶⣼⣿⠃⠀⢀⠧⠤⢜⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠟⠁⠀⠀⠀⡇⠀⣀⡈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠁⠐⠀⣀⠀⠀",
    "⠀⠙⠻⣿⠀⠀⠀⠀⠀⠀⢹⣿⣿⡝⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡿⠋⠀⠀⠀⠀⠠⠃⠁⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⡿⠋⠀⠀",
    "⠀⠀⠀⠙⡄⠀⠀⠀⠀⠀⢸⣿⣿⡃⢼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⡏⠉⠉⠻⣿⡿⠋⠀⠀⠀⠀",
    "⠀⠀⠀⠀⢰⠀⠀⠰⡒⠊⠻⠿⠋⠐⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠸⣇⡀⠀⠑⢄⠀⠀⠀⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢖⠠⠤⠤⠔⠙⠻⠿⠋⠱⡑⢄⠀⢠⠟⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠈⠉⠒⠒⠻⠶⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠡⢀⡵⠃⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠦⣀⠀⠀⠀⠀⠀⢀⣤⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠙⠛⠓⠒⠲⠿⢍⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "                            ",
  },
  buttons = {
    { txt = " Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "󰈔 Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭 Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "󱥚 Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "󰪛 Mappings", keys = "ch", cmd = "NvCheatsheet" },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    {
      -- Fixed: Simple text instead of function that requires lazy.nvim
      txt = "  Your drill is the drill that will pierce the heavens",
      hl = "NvDashFooter",
      no_gap = true,
    },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

-- Terminal configuration
M.term = {
  base46_colors = true,
  sizes = { sp = 0.3, vsp = 0.2 },
}

-- Cheatsheet configuration
M.cheatsheet = {
  theme = "grid", -- simple/grid
}

-- LSP signature configuration
M.lsp = {
  signature = true,
}

return M
