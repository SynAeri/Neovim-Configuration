-- config/lua/nvim-lspconfig.lua
local nvim_lsp = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.ts_ls.setup({
  -- Just use the tsserver from PATH
  -- No need to specify the exact nix store path
  capabilities = capabilities
})
nvim_lsp.lua_ls.setup({
  capabilities = capabilities
})

-- Python
nvim_lsp.pyright.setup({
  capabilities = capabilities,
})

-- Nix
nvim_lsp.nil_ls.setup({
  capabilities = capabilities,
})

-- C/C++
nvim_lsp.clangd.setup({
  capabilities = capabilities,
})

nvim_lsp.html.setup({
  capabilities = capabilities,
  filetypes = { "html", "templ" },
})

nvim_lsp.cssls.setup({
  capabilities = capabilities,
})


nvim_lsp.rust_analyzer.setup({
  capabilities = capabilities,
})

nvim_lsp.jsonls.setup({
  capabilities = capabilities,
})

nvim_lsp.sqls.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end
})
