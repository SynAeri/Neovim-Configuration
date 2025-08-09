require("obsidian").setup({

  -- Vaults
  workspaces = {
    {
      name = "work",
      path = "~/Obsidian/studyStuff",
    },

    {
      name = "personal",
      path = "~/Obsidian/personalStuff",
    },
  },

  -- log lvl
  log_level = vim.log.levels.INFO
})
