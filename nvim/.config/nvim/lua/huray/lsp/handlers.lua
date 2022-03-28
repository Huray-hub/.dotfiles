local M = {}

-- TODO: backfill this to template
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
    -- disable virtual text
    virtual_text = false,
    -- show signs
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
      source = 'always',
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

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function lsp_options(bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap

  keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gp", "<cmd>lua require'lsp.peek'.Peek('definition')<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

  keymap(bufnr, 'n', 'gp', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
  keymap(bufnr, 'n', 'gP', "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", opts)
  keymap(bufnr, 'n', 'gr', "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
  -- keymap(bufnr, "n", "gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR> ",opts)
  -- nnoremap gpd<cmd>lua require('goto-preview').goto_preview_definition()<CR>
  -- nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
  -- nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
  -- " Only set if you have telescope installed
  -- nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>

  keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  keymap(bufnr, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })<CR>', opts)
  keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  keymap(bufnr, 'n', '<leader>a', '<cmd>CodeActionMenu<CR>', opts)
  keymap(bufnr, 'v', '<leader>a', '<cmd>CodeActionMenu<CR>', opts)
  -- keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- keymap(bufnr, 'v', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- keymap(bufnr, 'n', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)
  -- keymap(bufnr, 'v', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

M.on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
  end

  if client.name == 'sqls' then
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.execute_command = true
    client.commands = require('sqls').commands
  end

  lsp_options(bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)

  -- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")

  vim.cmd([[
    augroup LspFormatting
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup END
    ]])
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
