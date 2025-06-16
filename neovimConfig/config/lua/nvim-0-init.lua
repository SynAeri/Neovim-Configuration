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
