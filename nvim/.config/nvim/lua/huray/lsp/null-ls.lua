local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
    return
end

local my_utils = require('huray.my-utils')

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

local _format_on_save = my_utils.augroup('_format_on_save', {})
null_ls.setup({
    on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({ group = _format_on_save, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
                desc = 'Format document on save',
                group = _format_on_save,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,

    debug = false,
    sources = {
        --[[ formatting.prettier.with({ extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' } }), ]]
        formatting.prettier.with({ filetypes = { 'css' } }),
        formatting.black.with({
            args = { '--stdin-filename', '$FILENAME', '--quiet', '-', '--fast', '--line-length', '79' },
        }),
        formatting.stylua,
        formatting.shfmt,
        --[[ formatting.sqlfluff, ]]
        --[[ formatting.sql_formatter.with({ ]]
        --[[     args = { '--config', vim.fn.glob(home .. '/.config/sql-formatter/sql-formatter.json') }, ]]
        --[[ }), ]]
        --[[ formatting.gofumpt, ]]
        --[[ formatting.goimports, ]]
        formatting.golines.with({
            args = { '--max-len', '100' },
        }),
        --[[ diagnostics.golangci_lint.with({ ]]
        --[[     args = { 'run', ]]
        --[[         '--fix=false', ]]
        --[[         '--fast', ]]
        --[[         '--out-format=json', ]]
        --[[         '$DIRNAME', ]]
        --[[         '--path-prefix', ]]
        --[[         '$ROOT' ]]
        --[[     }, ]]
        --[[ }), ]]
        diagnostics.flake8,
        diagnostics.shellcheck,
        diagnostics.zsh,
        --[[ diagnostics.sqlfluff, ]]
        --[[ diagnostics.staticcheck.with({ ]]
        --[[     args = { "-f", "json" , "./..." } ]]
        --[[ }), ]]
        code_actions.shellcheck,
    },
})
