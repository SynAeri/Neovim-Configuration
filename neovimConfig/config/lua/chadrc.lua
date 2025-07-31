-- config/lua/chadrc.lua
local M = {}


-- Function to load theme from external file
local function load_theme()
  local theme_file = vim.fn.stdpath("config") .. "/theme.lua"
  if vim.fn.filereadable(theme_file) == 1 then
    local theme_config = dofile(theme_file)
    return theme_config.theme or "onedark"
  end
  return "onedark" -- default theme
end

-- Function to save theme persistently
local function save_theme(theme_name)
  local theme_file = vim.fn.stdpath("data") .. "/nvchad_theme.lua"
  local content = string.format('return { theme = "%s" }', theme_name)
  
  local file = io.open(theme_file, "w")
  if file then
    file:write(content)
    file:close()
    print("Theme saved: " .. theme_name)
    return true
  end
  return false
end

-- Hook into NvChad's theme system
vim.api.nvim_create_autocmd("User", {
  pattern = "Base46ThemeChange",
  callback = function()
    local current_theme = vim.g.nvchad_theme
    if current_theme then
      save_theme(current_theme)
    end
  end,
})

-- Base46 configurations (theme should be here, not in ui)
M.base46 = {
  theme = load_theme(), -- Theme should be in base46, not ui
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
