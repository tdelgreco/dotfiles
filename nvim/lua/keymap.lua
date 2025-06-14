-- Key mappings
local opts = { noremap = true, silent = true }

-- Map <Ctrl-f> to open FZF in Normal Mode
vim.api.nvim_set_keymap('n', '<C-f>', ':FZF<CR>', opts)

-- Map <Alt-Esc> to quit without saving
vim.api.nvim_set_keymap('n', '<A-Esc>', ':q!<CR>', opts)
