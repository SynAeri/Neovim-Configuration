
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true


-- Theme setter

-- Custom theme persistence
local function save_theme(theme_name)
  local theme_file = vim.fn.stdpath("config") .. "/theme.lua"
  local content = string.format('return { theme = "%s" }', theme_name)
  
  -- Ensure config directory exists
  vim.fn.mkdir(vim.fn.stdpath("config"), "p")
  
  -- Write theme to file
  local file = io.open(theme_file, "w")
  if file then
    file:write(content)
    file:close()
    print("Theme saved: " .. theme_name)
  else
    print("Failed to save theme")
  end
end

-- Override the default theme switcher
local original_reload_theme = require("base46").reload_theme
require("base46").reload_theme = function(theme_name)
  -- Call original function
  original_reload_theme(theme_name)
  -- Save the theme
  save_theme(theme_name)
end

-- Create a command to manually save current theme
vim.api.nvim_create_user_command("SaveTheme", function(opts)
  local current_theme = vim.g.nvchad_theme or "onedark"
  if opts.args and opts.args ~= "" then
    current_theme = opts.args
  end
  save_theme(current_theme)
end, { nargs = "?" })

-- Create theme directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath("config"), "p")
