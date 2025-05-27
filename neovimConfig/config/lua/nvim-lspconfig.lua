-- config/lua/nvim-lspconfig.lua
local nvim_lsp = require("lspconfig")
nvim_lsp.tsserver.setup({
  -- Just use the tsserver from PATH
  -- No need to specify the exact nix store path
})
