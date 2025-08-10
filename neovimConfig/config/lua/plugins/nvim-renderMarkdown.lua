-- config/lua/plugins/nvim-render-markdown.lua
-- Dedicated configuration for render-markdown.nvim

require('render-markdown').setup({
  -- Basic settings
  enabled = true,
  render_modes = { 'n', 'c', 't' },
  preset = 'obsidian',  -- Use obsidian preset for callouts
  file_types = { 'markdown' },
  max_file_size = 10.0,
  debounce = 100,
  
  -- LaTeX math rendering with maximum concealment
  latex = {
    enabled = true,
    converter = 'latex2text',
    highlight = 'RenderMarkdownMath',
    position = 'above',  -- Show rendered math above
    top_pad = 0,
    bottom_pad = 0,
  },
  
  -- Anti-conceal settings - hide as much as possible in normal mode
  anti_conceal = {
    enabled = true,
    above = 0,  -- Don't show raw markdown above cursor
    below = 0,  -- Don't show raw markdown below cursor
    -- Remove most ignores to allow maximum concealment
    ignore = {
      -- Only keep essential elements that shouldn't be concealed
      sign = true,
    },
  },
  
  -- Window options for better concealment
  win_options = {
    conceallevel = {
      default = vim.o.conceallevel,
      rendered = 3,  -- Maximum concealment in normal mode
    },
    concealcursor = {
      default = vim.o.concealcursor,
      rendered = '',  -- Show concealed text in all modes when cursor on line
    },
  },
  
  -- Enhanced checkboxes
  checkbox = {
    enabled = true,
    unchecked = { icon = '󰄱 ', highlight = 'RenderMarkdownUnchecked' },
    checked = { icon = '󰱒 ', highlight = 'RenderMarkdownChecked' },
    custom = {
      todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
    },
  },
  
  -- Enhanced callouts for Obsidian
  callout = {
    note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
    tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
    important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
    warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
    -- Add more callouts as needed
  },
  
  -- Better heading rendering
  heading = {
    enabled = true,
    position = 'overlay',
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    width = 'full',
    border = false,
    backgrounds = {
      'RenderMarkdownH1Bg',
      'RenderMarkdownH2Bg', 
      'RenderMarkdownH3Bg',
      'RenderMarkdownH4Bg',
      'RenderMarkdownH5Bg',
      'RenderMarkdownH6Bg',
    },
  },
  
  -- Code block styling
  code = {
    enabled = true,
    sign = true,
    style = 'full',
    position = 'left',
    language_icon = true,
    language_name = true,
    width = 'full',
    border = 'hide',
  },
  
  -- List and bullet styling
  bullet = {
    enabled = true,
    icons = { '●', '○', '◆', '◇' },
    left_pad = 0,
    right_pad = 0,
  },
  
  -- Table styling
  pipe_table = {
    enabled = true,
    preset = 'none',
    cell = 'padded',
    border_enabled = true,
    alignment_indicator = '━',
  },
  
  -- Link styling
  link = {
    enabled = true,
    image = '󰥶 ',
    email = '󰀓 ',
    hyperlink = '󰌹 ',
    wiki = {
      icon = '󱗖 ',
      highlight = 'RenderMarkdownWikiLink',
    },
    custom = {
      web = { pattern = '^http', icon = '󰖟 ' },
      github = { pattern = 'github%.com', icon = '󰊤 ' },
    },
  },
  
  -- Quote styling
  quote = {
    enabled = true,
    icon = '▋',
    repeat_linebreak = false,
  },
  
  -- Inline highlights (==text==)
  inline_highlight = {
    enabled = true,
    highlight = 'RenderMarkdownInlineHighlight',
  },
})

-- Auto-conceal based on mode for true WYSIWYG LaTeX
vim.api.nvim_create_autocmd({"ModeChanged", "InsertEnter", "InsertLeave"}, {
  pattern = "*",
  callback = function()
    -- Only apply to markdown files
    if vim.bo.filetype ~= 'markdown' then return end
    
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'i' or mode == 'R' or mode == 'v' or mode == 'V' then
      -- Insert/Replace/Visual mode: show source
      vim.wo.conceallevel = 0
    else
      -- Normal mode: hide source, show only rendered
      vim.wo.conceallevel = 3
    end
  end,
})

