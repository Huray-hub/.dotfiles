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

-- adapter definitions
dap.adapters.cppdbg = { -- requires vscode's C/C++ extension
    id = 'cppdbg',
    type = 'executable',
    command = vim.fn.glob(home .. '/.vscode-server/extensions/ms-vscode.cpptools-*/debugAdapters/bin/OpenDebugAD7'),
}

dap.adapters.lldb = { -- requires llvm package
    type = 'executable',
    command = '/usr/bin/lldb-vscode', -- adjust as needed
    name = 'lldb',
}

dap.adapters.coreclr = {
    type = 'executable',
    command = '/usr/bin/netcoredbg',
    args = { '--interpreter=vscode' },
}

-- adapter configurations
dap.configurations.cs = {
    {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        -- program = function()
        --     return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        -- end,
        program = '${relativeFileDirname}/bin/Debug/net6.0/dotnet-notes.dll',
        cwd = '${workspaceFolder}',
    },
}

dap.configurations.cpp = {
    {
        name = 'Launch lldb',
        type = 'lldb',
        request = 'launch',
        program = '${relativeFileDirname}/a.out',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {
            '< input-data.txt',
        },
        MIMode = 'lldb',

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        runInTerminal = false,
        -- 💀
        -- If you use `runInTerminal = true` and resize the terminal window,
        -- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
        -- To avoid that uncomment the following option
        -- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
        postRunCommands = { 'process handle -p true -s false -n false SIGWINCH' },
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require('nvim-dap-virtual-text').setup()

local dap_ui_status_ok, dapui = pcall(require, 'dapui')
if not dap_ui_status_ok then
    return
end

dapui.setup({
    icons = { expanded = '▾', collapsed = '▸' },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
    },
    layouts = {
        {
            elements = {
                'scopes',
                'breakpoints',
                'stacks',
                'watches',
            },
            size = 40,
            position = 'left',
        },
        {
            elements = {
                'repl',
                'console',
            },
            size = 10,
            position = 'bottom',
        },
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = 'rounded', -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { 'q', '<Esc>' },
        },
    },
    windows = { indent = 1 },
})

require('dap-python').setup()
-- require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

--TODO: Replace vimscript with lua
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
