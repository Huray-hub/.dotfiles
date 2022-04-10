local status_ok, dap = pcall(require, 'dap')

if not status_ok then
  vim.notify('dap ' .. dap .. ' not found!')
  return
end

local icons = require('huray.icons')

dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
vim.fn.sign_define('DapBreakpoint', { text = icons.ui.Bug, texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = icons.ui.Bug, texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })

local home = os.getenv('HOME')

-- adapter definition
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = vim.fn.glob(home .. '/.vscode-server/extensions/ms-vscode.cpptools-*/debugAdapters/bin/OpenDebugAD7'),
}

dap.configurations.cpp = {
  {
    name = '(gdb) Launch file',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.getcwd() .. '/' .. 'a.out'
    end,
    cwd = '${workspaceFolder}',
    -- args = { '<', 'input1.txt' },
    stopOnEntry = true,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty printing',
        ignoreFailures = false,
      },
    },
    MIMode = 'gdb',
    externalConsole = false,
  },
  -- {
  -- 	name = "Attach to gdbserver :1234",
  -- 	type = "cppdbg",
  -- 	request = "launch",
  -- 	MIMode = "gdb",
  -- 	miDebuggerServerAddress = "localhost:1234",
  -- 	cwd = "${workspaceFolder}",
  -- 	program = function()
  -- 		return vim.fn.getcwd() .. "/", "a.out")
  -- 	end,
  -- },
}

dap.configurations.c = dap.configurations.cpp

require('nvim-dap-virtual-text').setup()
require('dapui').setup()

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap('n', '<F5>', "<cmd>lua require('dap').continue()<CR>", opts) --it also starts the execution in debug mode
keymap('n', '<F17>', "<cmd>lua require('dap').terminate()<CR>", opts) --F17 = S-F5
--TODO: map  F29 (= C-F5 to either 'run without debugger'  or 'restart debugger')
keymap('n', '<F10>', "<cmd>lua require('dap').step_over()<CR>", opts)
keymap('n', '<F11>', "<cmd>lua require('dap').step_into()<CR>", opts)
keymap('n', '<F22>', "<cmd>lua require('dap').step_out()<CR>", opts) --F22 -> S-F11
keymap('n', '<leader>db', "<cmd>lua require('dap').toggle_breakpoint()<CR>", opts)
keymap('n', '<leader>B', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap(
  'n',
  '<leader>lp',
  "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  opts
)
keymap('n', '<leader>dr', "<cmd>lua require('dap').repl.open()<CR>", opts)
keymap('n', '<leader>dl', "<cmd>lua require('dap').run_last()<CR>", opts)
