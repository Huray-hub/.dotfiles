local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap('n', '<C-h>', ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opts)
keymap('n', '<C-j>', ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opts)
keymap('n', '<C-k>', ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opts)
keymap('n', '<C-l>', ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opts)

keymap('n', '<leader>e', ":call VSCodeNotify('workbench.action.quickOpenNavigatePreviousInFilePicker')<CR>", opts)

-- Resize with arrows
-- keymap("n", "<C-Up>", ":resize -2<CR>", opts)
-- keymap("n", "<C-Down>", ":resize +2<CR>", opts)
-- keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
-- keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)
