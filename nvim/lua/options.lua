-- Enable syntax highlighting
vim.cmd('syntax on')
-- vim.cmd('colorscheme gruvbox')
-- vim.o.background = "dark"

-- Disable compatibility with Vi
vim.opt.compatible = false

-- Enable filetype detection, plugins, and indentation
vim.cmd([[
  filetype plugin indent on
]])

-- Set indentation and tab options
vim.opt.shiftwidth = 4   -- Number of spaces for each step of (auto)indent
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.opt.expandtab = true -- Use spaces instead of tabs

-- Disable backup files
vim.opt.backup = false
vim.opt.writebackup = false

-- Set scroll offset
vim.opt.scrolloff = 10 -- Keep 10 lines visible above and below the cursor

-- Disable line wrapping
vim.opt.wrap = false

-- Enable incremental search and highlight matches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.hlsearch = true  -- Highlight all search matches

-- Configure case-insensitive search with smart case
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true  -- Override ignorecase if search pattern contains uppercase letters

-- Show command in the last line of the screen
vim.opt.showcmd = true  -- Display incomplete commands
vim.opt.showmode = true -- Display the current mode

-- Show matching brackets or parentheses
vim.opt.showmatch = true

-- Increase history size
vim.opt.history = 1000

-- Configure wildmenu for command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = 'list:longest'
vim.opt.wildignore = { '*.docx', '*.jpg', '*.png', '*.gif', '*.pdf', '*.pyc', '*.exe', '*.flv', '*.img', '*.xlsx' }

-- Show line numbers
vim.opt.number = true

-- Highlight the current line
vim.opt.cursorline = true

-- Enable mouse support
vim.opt.mouse = 'a'

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight the current line
vim.opt.cursorline = true

-- Highlight the current column
vim.opt.cursorcolumn = false

-- Customize the status line
vim.opt.statusline = '%F'

-- Alternative tab and shiftwidth settings
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
