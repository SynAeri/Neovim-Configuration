-- config/lua/chadrc.lua
local M = {}

-- Function to load saved theme
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

-- Function to install theme hook (MOVED TO TOP)
local function install_theme_hook()
  local ok, base46 = pcall(require, "base46")
  if ok and base46.reload_theme then
    local original_reload = base46.reload_theme
    base46.reload_theme = function(theme_name)
      original_reload(theme_name)
      save_theme_to_file(theme_name)
    end
    print("✅ Theme auto-save hook installed")
    return true
  end
  return false
end

-- Simple theme picker command
vim.api.nvim_create_user_command("ThemePicker", function()
  -- Try to install hook first
  install_theme_hook()
  
  -- Open the theme picker
  local ok, themes = pcall(require, "nvchad.themes")
  if ok and themes.open then
    themes.open()
  else
    vim.notify("Theme picker not available", vim.log.levels.ERROR)
  end
end, { desc = "Open theme picker with auto-save" })

-- Debug command to check current theme
vim.api.nvim_create_user_command("ThemeDebug", function()
  print("=== Theme Debug Info ===")
  print("vim.g.nvchad_theme:", vim.g.nvchad_theme)
  print("vim.g.base46_theme:", vim.g.base46_theme) 
  print("vim.g.colors_name:", vim.g.colors_name)
  
  -- Check base46 cache
  local cache_file = vim.g.base46_cache .. "colors"
  if vim.fn.filereadable(cache_file) == 1 then
    local ok, colors = pcall(dofile, cache_file)
    if ok and colors then
      print("base46 cache theme:", colors.theme or "not found")
    end
  end
  
  -- Check nvconfig
  local ok, nvconfig = pcall(require, "nvconfig")
  if ok and nvconfig.base46 then
    print("nvconfig theme:", nvconfig.base46.theme)
  end
  
  -- Check what theme file we have saved
  local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
  if vim.fn.filereadable(theme_file) == 1 then
    local ok, saved = pcall(dofile, theme_file)
    if ok and saved then
      print("saved theme file:", saved.theme)
    end
  end
end, { desc = "Debug current theme detection" })

-- Better manual save that prompts for theme name
vim.api.nvim_create_user_command("SaveThemeAs", function()
  -- Get list of available themes
  local themes_ok, themes_module = pcall(require, "nvchad.themes")
  if themes_ok and themes_module.get_themes then
    local available_themes = themes_module.get_themes()
    if available_themes then
      vim.ui.select(available_themes, {
        prompt = "Select theme to save:",
      }, function(choice)
        if choice then
          save_theme_to_file(choice)
        end
      end)
      return
    end
  end
  
  -- Fallback to input
  vim.ui.input({
    prompt = "Enter theme name to save: ",
    default = "onedark"
  }, function(input)
    if input and input ~= "" then
      save_theme_to_file(input)
    end
  end)
end, { desc = "Save theme with selection" })
vim.api.nvim_create_user_command("SaveTheme", function(opts)
  local theme_name = opts.args
  
  if not theme_name or theme_name == "" then
    -- Method 1: Try to get from base46 cache
    local cache_file = vim.g.base46_cache .. "colors"
    if vim.fn.filereadable(cache_file) == 1 then
      local ok, colors = pcall(dofile, cache_file)
      if ok and colors and colors.theme then
        theme_name = colors.theme
      end
    end
    
    -- Method 2: Check various global variables
    if not theme_name then
      theme_name = vim.g.nvchad_theme or vim.g.base46_theme or vim.g.colors_name
    end
    
    -- Method 3: Try to read from nvconfig
    if not theme_name then
      local ok, nvconfig = pcall(require, "nvconfig")
      if ok and nvconfig.base46 and nvconfig.base46.theme then
        theme_name = nvconfig.base46.theme
      end
    end
    
    -- Method 4: Fallback to asking user
    if not theme_name then
      theme_name = vim.fn.input("Enter theme name: ")
      if theme_name == "" then
        theme_name = "onedark"
      end
    end
  end
  
  save_theme_to_file(theme_name)
end, { nargs = "?", desc = "Manually save current theme" })

-- Base46 configurations
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

-- Try to install hook after everything is loaded
vim.defer_fn(function()
  local attempts = 0
  local max_attempts = 5
  
  local function try_hook()
    attempts = attempts + 1
    if install_theme_hook() then
      return -- Success!
    elseif attempts < max_attempts then
      vim.defer_fn(try_hook, 1000) -- Try again in 1 second
    else
      print("❌ Theme auto-save hook failed after " .. max_attempts .. " attempts")
      print("   Use :SaveTheme after changing themes")
    end
  end
  
  try_hook()
end, 2000)

return M
