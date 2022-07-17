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
                -- '--reindent',
                -- '--indent_columns',
                -- '--reindent_aligned',
                '--use_space_around_operators',
            },
        }),
        -- formatting.sqlfluff,
        -- formatting.sqlfluff.with({
        --   args = { 'fix', '--disable_progress_bar', '-f', '-n', '-' },
        -- }),
        -- formatting.clang_format.with({ args = { '-style="{BasedOnStyle: llvm, IndentWidth: 4}"' } }),
        diagnostics.flake8,
        diagnostics.shellcheck,
        diagnostics.zsh,
        -- diagnostics.sqlfluff,
        -- diagnostics.sqlfluff.with({
        --   args = { 'lint', '-f', 'github-annotation', '-n', '--disable_progress_bar', '-' },
        -- }),
        code_actions.shellcheck,
    },
})
