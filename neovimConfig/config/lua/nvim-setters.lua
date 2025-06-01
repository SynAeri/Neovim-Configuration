-- Run current file based on filetype
vim.keymap.set('n', '<leader>rf', function()
  local overseer = require('overseer')
  local filetype = vim.bo.filetype
  
  local cmd = {
    python = "python3 %",
    javascript = "node %",
    typescript = "npx ts-node %",
    c = "gcc % -o %:r && ./%:r",
    cpp = "g++ % -o %:r && ./%:r",
    rust = "cargo run",
    go = "go run %",
  }
  
  if cmd[filetype] then
    overseer.run_template({ name = "shell", params = { cmd = cmd[filetype]:gsub("%%", vim.fn.expand("%")) }})
  end
end, { desc = "Run current file" })

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true

