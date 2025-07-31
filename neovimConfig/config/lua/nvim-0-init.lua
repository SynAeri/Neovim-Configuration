-- RUN FIRST TO SET THE CACHE OR CHECK
-- Set up cache directory for base46
local cache_dir = vim.fn.stdpath("cache") .. "/nvchad"
vim.fn.mkdir(cache_dir, "p")

-- Set the cache path for base46 before it loads
vim.g.base46_cache = cache_dir

-- Ensure data directory exists
local data_dir = vim.fn.stdpath("data")
vim.fn.mkdir(data_dir, "p")

vim.g.mapleader  = " "
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Delay slightly to ensure buffer information is available
    vim.defer_fn(function()
      -- Only show NvDash if no arguments were passed OR we have an empty [No Name] buffer
      if vim.fn.argc() == 0 or
         (vim.fn.bufname() == "" and vim.bo.buftype == "") then
	print("passed")
        pcall(require("nvchad.nvdash").open)
      end
    end, 100)
  end,
})
