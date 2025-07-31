
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true


-- Theme setter
-- Hook into NvChad's theme changing mechanism
local function setup_theme_persistence()
  -- Save theme when it changes
  local function save_current_theme()
    local current_theme = vim.g.nvchad_theme
    if current_theme then
      local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
      local content = string.format('return { theme = "%s" }', current_theme)
      
      local file = io.open(theme_file, "w")
      if file then
        file:write(content)
        file:close()
        vim.notify("Theme saved: " .. current_theme, vim.log.levels.INFO)
      end
    end
  end

  -- Override the reload_theme function to add persistence
  local function hook_theme_reload()
    local base46_ok, base46 = pcall(require, "base46")
    if base46_ok and base46.reload_theme then
      local original_reload = base46.reload_theme
      base46.reload_theme = function(theme_name)
        original_reload(theme_name)
        vim.schedule(function()
          save_current_theme()
        end)
      end
    end
  end

  -- Set up the hook after NvChad loads
  vim.defer_fn(function()
    hook_theme_reload()
  end, 100)

  -- Also create a manual save command
  vim.api.nvim_create_user_command("SaveTheme", function()
    save_current_theme()
  end, { desc = "Save current theme permanently" })
end

-- Initialize theme persistence
setup_theme_persistence()
