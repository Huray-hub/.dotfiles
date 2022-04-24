-- :h nvim_*
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_command -- this one executes commands
local set_global_option = vim.api.nvim_set_option
local set_option = vim.api.nvim_set_option_value

local buf_keymap = function(mode, lhs, rhs)
  local opts = { buffer = true, silent = true }
  vim.keymap.set(mode, lhs, rhs, opts)
end

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

autocmd('FileType', { --depends on bufferline.nvim
  desc = 'Cheakhealth filetypes will close with q',
  group = _general_settings,
  pattern = 'checkhealth',
  callback = function()
    buf_keymap('n', 'q', '<cmd>Bdelete!<CR>')
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlights text on yank(copy)',
  group = _general_settings,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Search', timeout = 200 })
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
    set_option('spell', true, { scope = 'local' })
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
local _alpha = augroup('_alpha', {})
autocmd('User', {
  desc = 'Hide tabs in alpha page',
  pattern = 'AlphaReady',
  group = _alpha,
  callback = function()
    set_global_option('showtabline', 0)
  end,
})

-- this is a bad workaround because I don't know how
-- to trigger it only when alpha menu is on
autocmd('BufUnload', {
  desc = 'Show tabs when leaving alpha page',
  group = _alpha,
  callback = function()
    if vim.bo.filetype == 'alpha' then
      set_global_option('showtabline', 2)
    end
  end,
})

---------------------------------------------------------------------
local _codelens = augroup('_codelens', {})
autocmd('BufWritePost', {
  desc = 'Refresh codelens virtual text after file saves',
  group = _codelens,
  pattern = '*.java',
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

---------------------------------------------------------------------
local _sql = augroup('_sql', {})
autocmd('FileType', {
  desc = 'Mappings for sql files',
  group = _sql,
  pattern = 'sql',
  callback = function()
    buf_keymap('n', '<leader>a', vim.lsp.buf.code_action)
    buf_keymap('v', '<leader>a', vim.lsp.buf.code_action)
    buf_keymap('n', '<F5>', '<Plug>(sqls-execute-query)')
    buf_keymap('v', '<F5>', '<Plug>(sqls-execute-query)')
  end,
})

autocmd('FileType', {
  desc = 'Sql output filetype opens in vertical split',
  group = _sql,
  pattern = 'sqls_output',
  callback = function()
    command('wincmd L')
  end,
})

-- Relative to installed programs
local _Xresources = augroup('_Xresources', {})
autocmd('BufWritePost', {
  desc = 'Run xrdb whenever Xresources are updated',
  group = _Xresources,
  pattern = '*Xresources',
  command = '!xrdb %',
})

local _sxhkd = augroup('_sxhkd', {})
autocmd('BufWritePost', {
  desc = 'Update binds when sxhkdrc is updated',
  group = _sxhkd,
  pattern = '*sxhkdrc',
  command = '!killall sxhkd; setsid sxhkd &',
})
