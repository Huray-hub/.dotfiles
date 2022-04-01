local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
  return
end

local helpers = require('null-ls.helpers')
local methods = require('null-ls.methods')

local sqlfluff = helpers.make_builtin({
  name = 'sqlfluff',
  method = methods.internal.DIAGNOSTICS,
  filetypes = { 'sql' },
  generator_opts = {
    command = 'sqlfluff',
    args = { 'lint', '--format', 'json', '-' },
    to_stdin = true,
    from_stderr = true,
    format = 'json',
    on_output = function(params)
      params.messages = params and params.output and params.output[1] and params.output[1].violations or {}

      local diagnostics = {}
      for _, json_diagnostic in ipairs(params.messages) do
        local diagnostic = {
          row = json_diagnostic['line_no'],
          col = json_diagnostic['line_pos'],
          code = json_diagnostic['code'],
          message = json_diagnostic['description'],
          severity = helpers.diagnostics.severities['information'],
        }

        table.insert(diagnostics, diagnostic)
      end

      return diagnostics
    end,
  },

  factory = helpers.generator_factory,
})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier.with({ extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' } }),
    -- formatting.black.with({ extra_args = { "--fast" } }),
    formatting.stylua,
    -- diagnostics.flake8,
    formatting.sqlformat.with({
      extra_args = {
        '--keywords',
        'upper',
        -- '--reindent',
        -- '--reindent_aligned',
      },
    }),
    diagnostics.shellcheck,
    sqlfluff,
  },
})
