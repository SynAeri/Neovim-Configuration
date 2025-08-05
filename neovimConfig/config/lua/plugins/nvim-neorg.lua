require("neorg").setup {
  -- Add your neorg configuration here
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
    ["core.export.markdown"] = {},
      config = {
        workspaces = {
          notes = "~/notes",
        },
      },
    },
  },
}
