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
    -- TODO: replace vimscript with lua
    -- local _lsp_document_highlight = vim.api.nvim_create_autogroup('_lsp_document_highlight', {})
    -- vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    --   desc = '',
    --   group = _lsp_document_highlight,
    --   callback = function()
    --     vim.lsp.buf.document_highlight()
    --   end,
    --   buffer = 0,
    -- })
    --
    -- vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    --   desc = '',
    --   group = _lsp_document_highlight,
    --   callback = function()
    --     vim.lsp.buf.clear_references()
    --   end,
    --   buffer = 0,
    -- })

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
  local buf_keymap = function(mode, lhs, rhs)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  buf_keymap('n', 'gD', vim.lsp.buf.declaration)
  buf_keymap('n', 'gd', vim.lsp.buf.definition)
  buf_keymap('n', 'K', vim.lsp.buf.hover)
  buf_keymap('n', 'gi', vim.lsp.buf.implementation)
  buf_keymap('n', '<C-k>', vim.lsp.buf.signature_help)
  buf_keymap('n', '<leader>rn', vim.lsp.buf.rename)
  buf_keymap('n', 'gr', vim.lsp.buf.references)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gp", "<cmd>lua require'lsp.peek'.Peek('definition')<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

  buf_keymap('n', 'gp', function()
    require('goto-preview').goto_preview_definition()
  end)
  buf_keymap('n', 'gP', function()
    require('goto-preview').goto_preview_implementation()
  end)
  buf_keymap('n', 'gr', function()
    require('goto-preview').close_all_win()
  end)
  -- keymap("n", "gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR> ",opts)
  -- nnoremap gpd<cmd>lua require('goto-preview').goto_preview_definition()<CR>
  -- nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
  -- nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
  -- " Only set if you have telescope installed
  -- nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>

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
    vim.api.nvim_command('CodeActionMenu')
  end)
  buf_keymap('v', '<leader>a', function()
    vim.api.nvim_command('CodeActionMenu')
  end)
  -- keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- keymap(bufnr, 'v', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- keymap(bufnr, 'n', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)
  -- keymap(bufnr, 'v', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)

  vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, { bang = true })
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
  lsp_highlight_document(client)

  -- TODO: replace vim with lua
  -- local _lsp_formatting = vim.api.nvim_create_augroup('_lsp_formatting', {})
  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --
  -- })
  vim.cmd([[
    augroup LspFormatting
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup END
    ]])
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
