local status_ok, dap = pcall(require, 'dap')
if not status_ok then
    vim.notify('dap ' .. dap .. ' not found!')
    return
end

local icons = require('huray.icons')

vim.api.nvim_set_hl(0, 'red', { ctermbg = 0, fg = '#993939', bg = '' })
vim.api.nvim_set_hl(0, 'blue', { ctermbg = 0, fg = '#61afef', bg = '' })
vim.api.nvim_set_hl(0, 'green', { ctermbg = 0, fg = '#98c379', bg = '' })
vim.api.nvim_set_hl(0, 'orange', { fg = '#f09000' })

dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
vim.fn.sign_define('DapBreakpoint', { text = icons.ui.Circle, texthl = 'red', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = icons.ui.Circle, texthl = 'orange', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = icons.ui.Circle, texthl = 'blue', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = icons.ui.BoldArrowRight, texthl = 'green', linehl = '', numhl = '' })

local home = os.getenv('HOME')
local mason_path = vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/')

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
            --[[ 'file.txt', ]]
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

--[[ dap.configurations.svelte = { ]]
--[[     type = 'chrome', ]]
--[[     request = 'attach', ]]
--[[     program = '${file}', ]]
--[[     cwd = vim.fn.getcwd(), ]]
--[[     sourceMaps = true, ]]
--[[     protocol = 'inspector', ]]
--[[     port = 5173, ]]
--[[     webRoot = '${workspaceFolder}', ]]
--[[ } ]]

local status_ok1, dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')
if not status_ok1 then
    return
end
dap_virtual_text.setup()

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
                --[[ 'console', ]]
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
require('dap-go').setup()

require('dap-vscode-js').setup({
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    debugger_path = mason_path .. '/js-debug-adapter', -- Path to vscode-js-debug installation.
    -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ 'typescript, javascript' }) do
    require('dap').configurations[language] = {
        {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
        },
    }
end

-- TODO: on startup, look for this directory in the project to load launch profiles
--
-- load json config from .vscode/launch.json
--[[ local root = vim.fn.finddir('.git/..', ';') ]]
--[[ print(root) ]]
--[[ require('dap.ext.vscode').load_launchjs(root .. '/.nvim/launch.json') -- parse .nvim/launch.json if exists ]]
--[[ require('dap.ext.vscode').load_launchjs(root .. '/.vscode/launch.json') -- parse .vscode/launch.json if exists ]]
--
--[[ require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. '/.nvim/launch.json') ]]
--[[ require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. '/.vscode/launch.json') ]]
