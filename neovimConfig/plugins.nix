{ pkgs }:
with pkgs.vimPlugins; [
  telescope-nvim
  plenary-nvim
  nvchad-ui
  base46
  nvim-web-devicons
  lazy-nvim
  nvim-treesitter.withAllGrammars

  neo-tree-nvim  
  toggleterm-nvim

  # Tree-sitter related plugins
  nvim-treesitter-textobjects  # Enhanced text objects
  nvim-treesitter-context      # Show current function/class context
  
  # Lsps
  nvim-lspconfig
  cmp-nvim-lsp

  # AutoCompletion
  nvim-cmp
  luasnip               # <-- snippet support
  cmp_luasnip           # <-- snippet completions

  # Aesthetics and simple QOL
  indent-blankline-nvim

  # Git Integrations
  gitsigns-nvim

  # Compiling
  compiler-nvim
]
