-- config/lua/plugins/nvim-peek.lua
require('peek').setup({
  auto_load = false,
  close_on_bdelete = true,
  syntax = true,
  theme = 'dark',
  update_on_change = true,
  app = 'webview',
  filetype = { 'markdown' },
  throttle_at = 200000,
  throttle_time = 'auto',
})

-- bspwm-aware open command
vim.api.nvim_create_user_command('PeekOpen', function()
  print("Opening peek preview...")
  require('peek').open()
  
  -- Give window time to appear, then try to focus it
  vim.defer_fn(function()
    print("Is peek open?", require('peek').is_open())
    -- Try to find and focus the peek window in bspwm
    vim.fn.system([[
      # Wait a bit more for window to fully appear
      sleep 0.5
      # Try to focus peek window by title (might need adjustment)
      xdotool search --name "Peek preview" windowactivate 2>/dev/null || 
      # Alternative: focus newest window
      bspc node newest.local -f 2>/dev/null || true
    ]])
  end, 1500)
end, {})
