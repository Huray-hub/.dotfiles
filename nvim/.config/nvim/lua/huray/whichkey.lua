local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = false, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '➜', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>', -- binding to scroll up inside the popup
    },
    window = {
        border = 'rounded', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = 'left', -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = 'auto', -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { 'j', 'k' },
        v = { 'j', 'k' },
    },
}

local opts = {
    mode = 'n', -- NORMAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local my_utils = require('huray.my-utils')
local mappings = {
    ['m'] = {
        function()
            my_utils.command('Alpha')
        end,
        'Alpha',
    },
    ['t'] = {
        function()
            require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))
        end,
        'Buffers',
    },
    ['b'] = {
        function()
            require('dap').toggle_breakpoint()
        end,
        'Toggle breakpoint',
    },
    ['B'] = {
        function()
            require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end,
        'Toggle conditional breakpoint',
    },
    ['d'] = {
        name = 'Debugging',
        b = {
            function()
                require('dap').toggle_breakpoint()
            end,
            'Breakpoint',
        },
        --TODO: replace this with lua function
        r = { "<cmd>lua require'dap'.repl.toggle({}, 'vsplit')<cr><C-W>l", 'Repl' },
        l = {
            function()
                require('dap').run_last()
            end,
            'Exit',
        },
        h = {
            function()
                require('dap.ui.widgets').hover()
            end,
            'Hover',
        },
        c = {
            function()
                require('dap').run_to_cursor()
            end,
            'Run to cursor',
        },
        C = {
            function()
                require('dap').clear_breakpoints()
            end,
            'Clear breakpoints',
        },
        k = {
            function()
                require('dap').up()
            end,
            'Move arrow up',
        },
        j = {
            function()
                require('dap').down()
            end,
            'Move arrow down',
        },
        L = {
            function()
                require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
            end,
            'breakpoint log message',
        },
        e = {
            function()
                require('dap').set_exception_breakpoints({ 'all' })
            end,
            'exception breakpoint',
        },
        a = {
            function()
                require('debugHelper').attach()
            end,
            'Attach',
        },
        A = {
            function()
                require('debugHelper').attachToRemote()
            end,
            'Attach to remote',
        },
        u = {
            function()
                require('dapui').toggle()
            end,
            'UI',
        },
        ['?'] = {
            function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end,
            'widgets?????',
        },
    },
    ['e'] = {
        function()
            my_utils.command('NvimTreeToggle')
        end,
        'Explorer',
    },
    ['w'] = {
        function()
            my_utils.command('w!')
        end,
        'Save',
    },
    ['c'] = {
        function()
            my_utils.command('Bdelete!')
        end,
        'Close Buffer',
    },
    ['C'] = {
        function()
            my_utils.command('silent! execute "%bd|e#|bd#"')
        end,
        'Close all buffers but this',
    },
    ['h'] = {
        function()
            my_utils.command('nohlsearch')
        end,
        'No Highlight',
    },
    ['f'] = {
        function()
            require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))
        end,
        'Find files',
    },
    ['F'] = {
        function()
            my_utils.command('Telescope live_grep theme=ivy')
        end,
        'Find Text',
    },
    ['P'] = {
        function()
            my_utils.command('Telescope projects')
        end,
        'Projects',
    },
    ['r'] = {
        function()
            require('renamer').rename({ empty = false })
        end,
        'Rename',
    },
    ['/'] = {
        function()
            require('Comment.api').toggle.linewise.current()
        end,
        'Comment',
    },
    ['Q'] = {
        function()
            my_utils.command('qa!')
        end,
        'Quit',
    },

    p = {
        name = 'Packer',
        c = {
            function()
                my_utils.command('PackerCompile')
            end,
            'Compile',
        },
        i = {
            function()
                my_utils.command('PackerInstall')
            end,
            'Install',
        },
        s = {
            function()
                my_utils.command('PackerSync')
            end,
            'Sync',
        },
        S = {
            function()
                my_utils.command('PackerStatus')
            end,
            'Status',
        },
        u = {
            function()
                my_utils.command('PackerUpdate')
            end,
            'Update',
        },
    },

    g = {
        name = 'Git',
        g = {
            function()
                _LAZYGIT_TOGGLE()
            end,
            'Lazygit',
        },
        j = {
            function()
                require('gitsigns').next_hunk()
            end,
            'Next Hunk',
        },
        k = {
            function()
                require('gitsigns').prev_hunk()
            end,
            'Prev Hunk',
        },
        l = {
            function()
                require('gitsigns').blame_line()
            end,
            'Blame',
        },
        p = {
            function()
                require('gitsigns').preview_hunk()
            end,
            'Preview Hunk',
        },
        r = {
            function()
                require('gitsigns').reset_hunk()
            end,
            'Reset Hunk',
        },
        R = {
            function()
                require('gitsigns').reset_buffer()
            end,
            'Reset Buffer',
        },
        s = {
            function()
                require('gitsigns').stage_hunk()
            end,
            'Stage Hunk',
        },
        u = {
            function()
                require('gitsigns').undo_stage_hunk()
            end,
            'Undo Stage Hunk',
        },
        o = {
            function()
                my_utils.command('Telescope git_status')
            end,
            'Open changed file',
        },
        b = {
            function()
                my_utils.command('Telescope git_branches')
            end,
            'Checkout branch',
        },
        c = {
            function()
                my_utils.command('Telescope git_commits')
            end,
            'Checkout commit',
        },
        d = {
            function()
                my_utils.command('Gitsigns diffthis HEAD')
            end,
            'Diff',
        },
    },

    l = {
        name = 'LSP',
        d = {
            function()
                my_utils.command('Telescope lsp_document_diagnostics')
            end,
            'Document Diagnostics',
        },
        w = {
            function()
                my_utils.command('Telescope lsp_workspace_diagnostics')
            end,
            'Workspace Diagnostics',
        },
        f = {
            function()
                vim.lsp.buf.formatting()
            end,
            'Format',
        },
        i = {
            function()
                my_utils.command('LspInfo')
            end,
            'Info',
        },
        I = {
            function()
                my_utils.command('LspInstallInfo')
            end,
            'Installer Info',
        },
        j = {
            function()
                vim.lsp.diagnostic.goto_next()
            end,
            'Next Diagnostic',
        },
        k = {
            function()
                vim.lsp.diagnostic.goto_prev()
            end,
            'Prev Diagnostic',
        },
        l = {
            function()
                vim.lsp.codelens.run()
            end,
            'CodeLens Action',
        },
        q = {
            function()
                vim.diagnostic.setloclist()
            end,
            'Quickfix',
        },
        r = {
            function()
                vim.lsp.buf.rename()
            end,
            'Rename',
        },
        s = {
            function()
                my_utils.command('Telescope lsp_document_symbols')
            end,
            'Document Symbols',
        },
        S = {
            function()
                my_utils.command('Telescope lsp_dynamic_workspace_symbols')
            end,
            'Workspace Symbols',
        },
    },
    s = {
        name = 'Search',
        b = {
            function()
                my_utils.command('Telescope git_branches')
            end,
            'Checkout branch',
        },
        c = {
            function()
                my_utils.command('Telescope colorscheme')
            end,
            'Colorscheme',
        },
        h = {
            function()
                my_utils.command('Telescope help_tags')
            end,
            'Find Help',
        },
        M = {
            function()
                my_utils.command('Telescope man_pages')
            end,
            'Man Pages',
        },
        r = {
            function()
                my_utils.command('Telescope oldfiles')
            end,
            'Open Recent File',
        },
        R = {
            function()
                my_utils.command('Telescope registers')
            end,
            'Registers',
        },
        k = {
            function()
                my_utils.command('Telescope keymaps')
            end,
            'Keymaps',
        },
        C = {
            function()
                my_utils.command('Telescope commands')
            end,
            'Commands',
        },
    },

    ['O'] = { '<Plug>SearchNormal', 'Open Link' },

    T = {
        name = 'Terminal',
        n = {
            function()
                _NODE_TOGGLE()
            end,
            'Node',
        },
        u = {
            function()
                _NCDU_TOGGLE()
            end,
            'NCDU',
        },
        t = {
            function()
                _HTOP_TOGGLE()
            end,
            'Htop',
        },
        p = {
            function()
                _PYTHON_TOGGLE()
            end,
            'Python',
        },
        f = {
            function()
                my_utils.command('ToggleTerm direction=float')
            end,
            'Float',
        },
        h = {
            function()
                my_utils.command('ToggleTerm size=10 direction=horizontal')
            end,
            'Horizontal',
        },
        v = {
            function()
                my_utils.command('ToggleTerm size=80 direction=vertical')
            end,
            'Vertical',
        },
    },
}

local vopts = {
    mode = 'v', -- VISUAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
    ['/'] = {
        --TODO: replace this with lua function
        '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
        'Comment',
    },
    ['O'] = { '<Plug>SearchVisual', 'Open Link' },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
