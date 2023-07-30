-- :h nvim_*
local my_utils = require('huray.my-utils')

local augroup = my_utils.augroup
local autocmd = my_utils.autocmd
local command = my_utils.command
local set_option = my_utils.set_option
local buf_keymap = my_utils.buf_keymap

---------------------------------------------------------------------
local _general_settings = augroup('_general_settings', {})
autocmd('FileType', {
    desc = 'These filetypes will close with q',
    group = _general_settings,
    pattern = { 'qf', 'help', 'man', 'lspinfo', 'null-ls-info', 'sqls_output' },
    callback = function()
        buf_keymap('n', 'q', function()
            vim.api.nvim_win_close(0, false)
        end)
    end,
})

autocmd('FileType', {
    desc = 'Close Quickfix list on leaving',
    group = _general_settings,
    pattern = 'qf',
    callback = function()
        buf_keymap('n', '<CR>', '<CR><CMD>cclose<CR>')
        --[[ buf_keymap('n', '<CR>', function() ]]
        --[[     enter here somehow ]]
        --[[     command('cclose') ]]
        --[[  end)  ]]
    end,
})

autocmd('FileType', { --depends on bufferline.nvim
    desc = 'Cheakhealth filetypes will close with q',
    group = _general_settings,
    pattern = 'checkhealth',
    callback = function()
        buf_keymap('n', 'q', '<cmd>Bdelete!<CR>')
    end,
})

autocmd('FileType', {
    desc = 'Dap-float filetypes will close with Esc',
    group = _general_settings,
    pattern = 'dap-float',
    callback = function()
        buf_keymap('n', '<Esc>', function()
            vim.api.nvim_win_close(0, false)
        end)
    end,
})

autocmd('FileType', {
    desc = 'Quickfix Lists will close with q',
    group = _general_settings,
    pattern = 'qf',
    callback = function()
        buf_keymap('n', '<Esc>', function()
            vim.api.nvim_win_close(0, false)
        end)
    end,
})

autocmd('TextYankPost', {
    desc = 'Highlights text on yank(copy)',
    group = _general_settings,
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    end,
})

autocmd('BufWinEnter', {
    desc = 'TODO: understand and describe this one',
    group = _general_settings,
    callback = function()
        vim.opt.formatoptions:remove('cro')
    end,
})

autocmd('FileType', {
    desc = 'Quickfix files will not be listed in bufferlist',
    group = _general_settings,
    pattern = 'qf',
    callback = function()
        command('set nobuflisted')
    end,
})

autocmd('FileType', {
    desc = 'Help opens in vertical split',
    group = _general_settings,
    pattern = 'help',
    callback = function()
        command('wincmd L')
        command('vert resize 90')
    end,
})

---------------------------------------------------------------------
local _git = augroup('_git', {})
autocmd('FileType', {
    desc = 'Setting for gitcommit files',
    group = _git,
    pattern = 'gitcommit',
    callback = function()
        set_option('wrap', true, { scope = 'local' })
        set_option('spell', true, { scope = 'local' })
    end,
})

---------------------------------------------------------------------
local _markdown = augroup('_markdown', {})
autocmd('FileType', {
    desc = 'Settings for markdown files',
    group = _markdown,
    pattern = 'markdown',
    callback = function()
        set_option('wrap', true, { scope = 'local' })
        --[[ set_option('spell', true, { scope = 'local' }) ]]
    end,
})

---------------------------------------------------------------------
local _auto_resize = augroup('_auto_resize', {})
autocmd('VimResized', {
    desc = '',
    group = _auto_resize,
    callback = function()
        command('tabdo wincmd =')
    end,
})

---------------------------------------------------------------------
local _codelens = augroup('_codelens', {})
autocmd('BufWritePost', {
    desc = 'Refresh codelens virtual text after file saves',
    group = _codelens,
    pattern = { '*.java', '*.go' },
    callback = function()
        vim.lsp.codelens.refresh()
    end,
})

---------------------------------------------------------------------
local _sql = augroup('_sql', {})
autocmd('FileType', {
    desc = 'Sql output filetype opens in vertical split',
    group = _sql,
    pattern = 'sqls_output',
    callback = function()
        command('wincmd J')
    end,
})

---------------------------------------------------------------------
local _launchjs_json = augroup('_launchjs_json', {})
autocmd('BufWritePost', {
    desc = 'Reload debug settings on launch.json save',
    group = _launchjs_json,
    pattern = 'launch.json',
    command = 'lua require("dap.ext.vscode").load_launchjs()',
})

autocmd('DirChanged', {
    desc = 'Reload debug settings on dir change',
    group = _launchjs_json,
    command = 'lua require("dap.ext.vscode").load_launchjs()',
})

---------------------------------------------------------------------
autocmd({ 'CursorHold' }, {
    callback = function()
        local status_ok, luasnip = pcall(require, 'luasnip')
        if not status_ok then
            return
        end
        if luasnip.expand_or_jumpable() then
            -- ask maintainer for option to make this silent
            -- luasnip.unlink_current()
            vim.cmd([[silent! lua require("luasnip").unlink_current()]])
        end
    end,
})

----------------------------------------------------------------------
local _format_sync_go_grp = vim.api.nvim_create_augroup('GoImport', {})
autocmd('BufWritePre', {
    desc = 'Run gofmt + goimport on save',
    pattern = '*.go',
    callback = function()
        command('GoFmt')
    end,
    group = _format_sync_go_grp,
})
