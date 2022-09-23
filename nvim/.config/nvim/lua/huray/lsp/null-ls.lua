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

null_ls.setup({
    debug = false,
    sources = {
        formatting.prettier.with({ extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' } }),
        formatting.black.with({
            args = { '--stdin-filename', '$FILENAME', '--quiet', '-', '--fast', '--line-length', '79' },
        }),
        formatting.stylua,
        formatting.shfmt,
        formatting.sqlformat.with({
            extra_args = {
                '--keywords',
                'upper',
                '--identifiers',
                'upper',
                '--indent_width',
                '2',
                '--indent_after_first',
                '--use_space_around_operators',
            },
        }),
        diagnostics.flake8,
        diagnostics.shellcheck,
        diagnostics.zsh,
        code_actions.shellcheck,
    },
})
