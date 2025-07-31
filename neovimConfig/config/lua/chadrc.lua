-- config/lua/chadrc.lua
local M = {}

-- Function to load saved theme
local function load_saved_theme()
  local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
  if vim.fn.filereadable(theme_file) == 1 then
    local ok, theme_config = pcall(dofile, theme_file)
    if ok and theme_config and theme_config.theme and theme_config.theme ~= "" then
      print("Loading saved theme: " .. theme_config.theme)
      return theme_config.theme
    end
  end
  print("Using default theme: onedark")
  return "onedark" -- default fallback
end

-- Function to save theme persistently with validation
local function save_theme_to_file(theme_name)
  print("save_theme_to_file called with:", theme_name, "type:", type(theme_name))
  
  if not theme_name or theme_name == "" then
    print("ERROR: theme_name is empty or nil!")
    return false
  end
  
  local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
  local content = string.format('return { theme = "%s" }', theme_name)
  
  print("Writing to file:", theme_file)
  print("Content:", content)
  
  local file = io.open(theme_file, "w")
  if file then
    file:write(content)
    file:close()
    vim.notify("Theme saved: " .. theme_name, vim.log.levels.INFO)
    return true
  else
    print("ERROR: Could not open file for writing!")
    return false
  end
end

-- Function to install theme hook
local function install_theme_hook()
  local ok, base46 = pcall(require, "base46")
  if ok and base46.reload_theme then
    local original_reload = base46.reload_theme
    base46.reload_theme = function(theme_name)
      original_reload(theme_name)
      -- Use nvconfig as backup since theme_name parameter might be unreliable
      vim.defer_fn(function()
        local config_ok, nvconfig = pcall(require, "nvconfig")
        if config_ok and nvconfig.base46 and nvconfig.base46.theme then
          save_theme_to_file(nvconfig.base46.theme)
        else
          save_theme_to_file(theme_name)
        end
      end, 100)
    end
    print("✅ Theme auto-save hook installed")
    return true
  end
  return false
end

-- Enhanced theme picker command that ensures hook is installed
vim.api.nvim_create_user_command("ThemePicker", function()
  -- Force hook installation right before opening picker
  local hook_installed = install_theme_hook()
  
  if hook_installed then
    print("🎨 Theme picker opened with auto-save enabled")
  else
    print("⚠️  Theme picker opened - use :SaveTheme to save themes manually")
  end
  
  -- Open the theme picker
  local ok, themes = pcall(require, "nvchad.themes")
  if ok and themes.open then
    themes.open()
    
    -- Fallback: Auto-save after a delay (in case hook doesn't work)
    vim.defer_fn(function()
      local config_ok, nvconfig = pcall(require, "nvconfig")
      if config_ok and nvconfig.base46 and nvconfig.base46.theme then
        local current_theme = nvconfig.base46.theme
        -- Check if theme file has the current theme
        local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
        if vim.fn.filereadable(theme_file) == 1 then
          local file_ok, saved_config = pcall(dofile, theme_file)
          if not (file_ok and saved_config and saved_config.theme == current_theme) then
            print("📝 Auto-saving theme after picker closed...")
            save_theme_to_file(current_theme)
          end
        end
      end
    end, 2000) -- Wait 2 seconds after theme picker opens
  else
    vim.notify("Theme picker not available", vim.log.levels.ERROR)
  end
end, { desc = "Open theme picker with auto-save" })

-- SIMPLIFIED SaveTheme command that uses nvconfig directly
vim.api.nvim_create_user_command("SaveTheme", function(opts)
  local theme_name = opts.args
  
  if not theme_name or theme_name == "" then
    -- Get current theme from nvconfig (we know this works!)
    local ok, nvconfig = pcall(require, "nvconfig")
    if ok and nvconfig.base46 and nvconfig.base46.theme then
      theme_name = nvconfig.base46.theme
      print("Got theme from nvconfig:", theme_name)
    else
      theme_name = "onedark" -- fallback
    end
  end
  
  save_theme_to_file(theme_name)
end, { nargs = "?", desc = "Save current theme" })

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
