local my_utils = require('huray.my-utils')

local M = {}

M.setup = function()
    local icons = require('huray.icons')
    local signs = {
        { name = 'DiagnosticSignError', text = icons.diagnostics.Error },
        { name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning },
        { name = 'DiagnosticSignHint', text = icons.diagnostics.Hint },
        { name = 'DiagnosticSignInfo', text = icons.diagnostics.Information },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
    end

    local config = {
        virtual_text = false,
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = 'minimal',
            border = 'rounded',
            source = 'if_many', -- or "always"
            header = '',
            prefix = '',
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
    })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
    })
end

local function lsp_options(bufnr)
    my_utils.buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc', bufnr)
end

local function lsp_keymaps(bufnr)
    local create_command = my_utils.create_command
    local command = my_utils.command
    local buf_keymap = function(mode, lhs, rhs)
        my_utils.buf_keymap(mode, lhs, rhs, bufnr)
    end

    buf_keymap('n', 'gD', vim.lsp.buf.declaration)
    buf_keymap('n', 'gd', vim.lsp.buf.definition)
    buf_keymap('n', 'K', vim.lsp.buf.hover)
    buf_keymap('n', 'gi', vim.lsp.buf.implementation)
    buf_keymap('n', '<C-k>', vim.lsp.buf.signature_help)
    buf_keymap('n', '<leader>rn', vim.lsp.buf.rename)
    buf_keymap('n', 'gr', vim.lsp.buf.references)
    buf_keymap('n', '[d', function()
        vim.diagnostic.goto_prev({ border = 'rounded' })
    end)
    buf_keymap('n', 'gl', function()
        vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' })
    end)
    buf_keymap('n', ']d', function()
        vim.diagnostic.goto_next({ border = 'rounded' })
    end)
    buf_keymap('n', '<leader>q', vim.diagnostic.setloclist)
    buf_keymap('n', '<leader>a', function()
        command('CodeActionMenu')
    end)
    buf_keymap('v', '<leader>a', function()
        command('CodeActionMenu')
    end)

    create_command('Format', vim.lsp.buf.formatting, { bang = true })
end

M.on_attach = function(client, bufnr)
    if client.name == 'tsserver' or client.name == 'sumneko_lua' then
        client.resolved_capabilities.document_formatting = false
    end

    if client.name == 'sqls' then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.execute_command = true
        client.commands = require('sqls').commands
        require('sqls').on_attach(client, bufnr)
    end

    if client.name == 'jdt.ls' then
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        require('jdtls.dap').setup_dap_main_class_configs()
        vim.lsp.codelens.refresh()
    end

    lsp_options(bufnr)
    lsp_keymaps(bufnr)

    local _format_on_save = my_utils.augroup('_format_on_save', {})
    my_utils.autocmd('BufWritePre', {
        desc = 'Format document on save',
        buffer = 0,
        group = _format_on_save,
        callback = function()
            vim.lsp.buf.formatting_sync()
        end,
    })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
