local my_utils = require('huray.my-utils')
local keymap = my_utils.keymap
local command = my_utils.command

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap('n', '<C-h>', command("call VSCodeNotify('workbench.action.navigateLeft')"))
keymap('n', '<C-j>', command("call VSCodeNotify('workbench.action.navigateDown')"))
keymap('n', '<C-k>', command("call VSCodeNotify('workbench.action.navigateUp')"))
keymap('n', '<C-l>', command("call VSCodeNotify('workbench.action.navigateRight')"))

keymap('n', '<leader>e', command("call VSCodeNotify('workbench.action.quickOpenNavigatePreviousInFilePicker')"))

-- Resize with arrows
-- keymap("n", "<C-Up>", ":resize -2<CR>")
-- keymap("n", "<C-Down>", ":resize +2<CR>")
-- keymap("n", "<C-Left>", ":vertical resize -2<CR>")
-- keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>")
-- keymap("n", "<S-h>", ":bprevious<CR>")
