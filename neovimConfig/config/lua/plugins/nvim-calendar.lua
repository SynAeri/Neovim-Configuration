-- Set up calendar.vim for Google integration
vim.g.calendar_google_calendar = 1
vim.g.calendar_google_task = 1

-- calendar settings
vim.g.calendar_frame = 'default'
vim.g.calendar_google_calendar_readonly = 0
vim.g.calendar_google_task_readonly = 0

-- Source credentials if they exist
local credentials_file = vim.fn.expand("~/.cache/calendar.vim/credentials.vim")
if vim.fn.filereadable(credentials_file) == 1 then
  vim.cmd("source " .. credentials_file)
else
  print("Calendar credentials not found")
end
