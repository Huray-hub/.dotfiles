local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
    return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

local home = os.getenv('HOME')

null_ls.setup({
    debug = false,
    sources = {
        formatting.prettier.with({ extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' } }),
        formatting.black.with({
            args = { '--stdin-filename', '$FILENAME', '--quiet', '-', '--fast', '--line-length', '79' },
        }),
        formatting.stylua,
        formatting.shfmt,
        formatting.sql_formatter.with({
            args = { '--config', vim.fn.glob(home .. '/.config/sql-formatter/sql-formatter.json') },
        }),
        --[[ formatting.gofumpt, ]]
        --[[ formatting.goimports, ]]
        formatting.golines.with({
            args = { '--max-len', '90' },
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
        --[[ diagnostics.staticcheck.with({ ]]
        --[[     args = { "-f", "json" , "./..." } ]]
        --[[ }), ]]
        code_actions.shellcheck,
    },
})
