local status_ok, toggleterm = pcall(require, 'toggleterm')
local my_utils = require('huray.my-utils')
local buf_keymap = my_utils.buf_keymap
if not status_ok then
  return
end

toggleterm.setup({
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = 'Normal',
      background = 'Normal',
    },
  },
})

function _G.set_terminal_keymaps()
  buf_keymap('t', '<esc>', [[<C-\><C-n>]])
  buf_keymap('t', 'jk', [[<C-\><C-n>]])
  buf_keymap('t', '<C-h>', [[<C-\><C-n><C-W>h]])
  buf_keymap('t', '<C-j>', [[<C-\><C-n><C-W>j]])
  buf_keymap('t', '<C-k>', [[<C-\><C-n><C-W>k]])
  buf_keymap('t', '<C-l>', [[<C-\><C-n><C-W>l]])
end

-- TODO: refactor this to lua
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true })

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

local node = Terminal:new({ cmd = 'node', hidden = true })

function _NODE_TOGGLE()
  node:toggle()
end

local ncdu = Terminal:new({ cmd = 'ncdu', hidden = true })

function _NCDU_TOGGLE()
  ncdu:toggle()
end

local htop = Terminal:new({ cmd = 'htop', hidden = true })

function _HTOP_TOGGLE()
  htop:toggle()
end

local python = Terminal:new({ cmd = 'python', hidden = true })

function _PYTHON_TOGGLE()
  python:toggle()
end
