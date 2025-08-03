-- config/lua/chadrc.lua
local M = {}

-- Function to load saved theme
local function load_saved_theme()
  local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
  if vim.fn.filereadable(theme_file) == 1 then
    local ok, theme_config = pcall(dofile, theme_file)
    if ok and theme_config and theme_config.theme and theme_config.theme ~= "" then
      --print("Loading saved theme: " .. theme_config.theme)
      return theme_config.theme
    end
  end
  print("Using default theme: onedark")
  return "onedark"
end

-- Function to save theme persistently
local function save_theme_to_file(theme_name)
  if not theme_name or theme_name == "" then
    print("ERROR: theme_name is empty!")
    return false
  end
  
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

-- Simple and reliable SaveTheme command
vim.api.nvim_create_user_command("SaveTheme", function(opts)
  local theme_name = opts.args
  
  if not theme_name or theme_name == "" then
    -- Get current theme from nvconfig (we know this works!)
    local ok, nvconfig = pcall(require, "nvconfig")
    if ok and nvconfig.base46 and nvconfig.base46.theme then
      theme_name = nvconfig.base46.theme
    else
      theme_name = "onedark"
    end
  end
  
  save_theme_to_file(theme_name)
end, { nargs = "?", desc = "Save current theme" })

-- Smart theme picker that auto-saves after selection
vim.api.nvim_create_user_command("ThemePicker", function()
  -- Open the theme picker
  local ok, themes = pcall(require, "nvchad.themes")
  if ok and themes.open then
    themes.open()
    
    -- Auto-save after a short delay to let theme picker close
    vim.defer_fn(function()
      vim.cmd("SaveTheme")
    end, 1500)
  else
    vim.notify("Theme picker not available", vim.log.levels.ERROR)
  end
end, { desc = "Open theme picker with auto-save" })

-- Base46 configurations
M.base46 = {
  theme = load_saved_theme(),
  hl_add = {},
  hl_override = {},
  integrations = {},
  changed_themes = {},
  transparency = false,
  theme_toggle = { "onedark", "one_light" },
}

-- UI configurations
M.ui = {
  statusline = {
    theme = "vscode_colored",
    separator_style = "default",
  },
  tabufline = {
    enabled = true,
    lazyload = false,
  },
  cmp = {
    lspkind_text = true,
    style = "default",
  },
  telescope = { style = "borderless" },
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
    { txt = "󱥚 Themes", keys = "th", cmd = ":ThemePicker" },
    { txt = "󱥚 Note: Savetheme After picking Themes", keys = "St", cmd = ":SaveTheme" },
    { txt = "󰪛 Mappings", keys = "ch", cmd = "NvCheatsheet" },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    {
      txt = "  Your drill is the drill that will pierce the heavens",
      hl = "NvDashFooter",
      no_gap = true,
    },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

M.term = {
  base46_colors = true,
  sizes = { sp = 0.3, vsp = 0.2 },
}

M.cheatsheet = {
  theme = "grid",
}

M.lsp = {
  signature = true,
}

return M
