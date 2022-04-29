local my_utils = require('huray.my-utils')
local keymap = my_utils.keymap
local set_global_variable = my_utils.set_global_variable
local command = my_utils.command

-- Modes
--   all_modes = ''
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

--Remap space as leader key
keymap('', '<Space>', '<Nop>')
set_global_variable('mapleader', ' ')
set_global_variable('maplocalleader', ' ')

-- Normal --
-- Better window navigation
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Resize with arrows
keymap('n', '<C-Up>', function()
  command('resize -2')
end)
keymap('n', '<C-Down>', function()
  command('resize +2')
end)
keymap('n', '<C-Left>', function()
  command('vertical resize -2')
end)
keymap('n', '<C-Right>', function()
  command('vertical resize +2')
end)

-- Navigate buffers
keymap('n', '<S-l>', function()
  command('bnext')
end)
keymap('n', '<S-h>', function()
  command('bprevious')
end)

-- Move text up and down
-- keymap('n', '<A-j>', '<Esc>:m .+1<CR>==gi')
-- keymap('n', '<A-k>', '<Esc>:m .-2<CR>==gi')

-- Keep search navigation centered
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
--keymap("n", "J", "mzJ`z")
keymap('n', 'n', 'nzzzv')

-- Insert --
-- Undo break points
keymap('i', ',', ',<C-g>u')
keymap('i', '.', '.<C-g>u')
keymap('i', '!', '!<C-g>u')
keymap('i', '?', '?<C-g>u')

-- TODO: inoremap <expr> <Tab> stridx('])}', getline('.')[col('.')-1])==-1 ? "\t" : "\<Right>"

-- Visual --
-- Stay in indent mode
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Move text up and down
keymap('v', '<A-j>', ':m .+1<CR>==')
keymap('v', '<A-k>', ':m .-2<CR>==')
keymap('v', 'p', '"_dP')

-- Visual Block --
-- Move text up and down
keymap('x', 'J', ":move '>+1<CR>gv-gv")
keymap('x', 'K', ":move '<-2<CR>gv-gv")
keymap('x', '<A-j>', ":move '>+1<CR>gv-gv")
keymap('x', '<A-k>', ":move '<-2<CR>gv-gv")
