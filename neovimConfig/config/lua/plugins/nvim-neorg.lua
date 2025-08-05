use {
  "nvim-neorg/neorg",
  rocks = { "lua-utils.nvim", "nvim-nio", "nui.nvim", "plenary.nvim", "pathlib.nvim", "nvim-treesitter-legacy-api" },
  tag = "*", -- Pin Neorg to the latest stable release
  config = function()
      require("neorg").setup()
  end,
}
