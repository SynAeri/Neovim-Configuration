-- config/lua/nvim-lspconfig.lua
local nvim_lsp = require("lspconfig")
nvim_lsp.ts_ls.setup({
  -- Just use the tsserver from PATH
  -- No need to specify the exact nix store path
})
nvim_lsp.lua_ls.setup({
})
