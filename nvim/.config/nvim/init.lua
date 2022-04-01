require('huray.options')
require('huray.keymaps')
require('huray.plugins')
require('huray.cmp')
require('huray.lsp')
require('huray.telescope')
require('huray.treesitter')
require('huray.autopairs')
require('huray.comment')
require('huray.gitsigns')
require('huray.impatient')
require('huray.indentline')
require('huray.autocommands')

if vim.g.vscode then
  require('huray.vscode-keymaps')
  return
end

require('huray.nvim-tree')
require('huray.bufferline')
require('huray.alpha')
require('huray.lualine')
require('huray.toggleterm')
require('huray.project')
require('huray.whichkey')
require('huray.colorscheme')
require('huray.codeActionMenu')
require('huray.lightbulb')
require('huray.dap')
require('huray.lsp.goto-preview')