-- Automatically install lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- General
    'wbthomason/packer.nvim', -- Have packer manage itself
    'nvim-lua/popup.nvim', -- An implementation of the Popup API from vim in Neovim
    'nvim-lua/plenary.nvim', -- Useful lua functions used ny lots of plugins
    'nvim-tree/nvim-web-devicons',
    'kyazdani42/nvim-tree.lua',
    'moll/vim-bbye',
    'nvim-lualine/lualine.nvim',
    'akinsho/toggleterm.nvim',
    'ahmedkhalf/project.nvim',
    'lewis6991/impatient.nvim',
    'folke/which-key.nvim',
    'kosayoda/nvim-lightbulb',

    -- Convenience
    'kylechui/nvim-surround', -- Surround text-objects with letters
    'voldikss/vim-browser-search', -- Open Urls to Browser
    'norcalli/nvim-colorizer.lua', -- Colors on hex codes
    'Shatur/neovim-session-manager', -- Session support
    'windwp/nvim-autopairs', -- Autopairs, integrates with both cmp and treesitter
    'numToStr/Comment.nvim', -- Easily comment stuff
    'lukas-reineke/indent-blankline.nvim',
    'RRethy/vim-illuminate',
    'filipdutescu/renamer.nvim',
    'stevearc/dressing.nvim',
    { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' }, -- Modern looks for folding
    'windwp/nvim-ts-autotag',
    'uga-rosa/translate.nvim',
    'b0o/incline.nvim',
    { 'folke/trouble.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },
    {
        'lukas-reineke/headlines.nvim',
        dependencies = 'nvim-treesitter',
    },
    -- Colorschemes
    'folke/tokyonight.nvim',
    'Mofiqul/dracula.nvim',
    'ellisonleao/gruvbox.nvim',
    { 'EdenEast/nightfox.nvim', version = 'v1.0.0' },
    'xiyaowong/nvim-transparent',

    -- Cmp plugins
    'hrsh7th/nvim-cmp', -- The completion plugin
    'hrsh7th/cmp-buffer', -- buffer completions
    'hrsh7th/cmp-path', -- path completions
    'hrsh7th/cmp-cmdline', -- cmdline completions
    'saadparwaiz1/cmp_luasnip', -- snippet completions
    'hrsh7th/cmp-nvim-lsp',
    'rcarriga/cmp-dap', -- completion for dap buffers

    -- Snippets
    'L3MON4D3/LuaSnip', --snippet engine
    'rafamadriz/friendly-snippets', -- a bunch of snippets to use

    -- LSP
    'neovim/nvim-lspconfig', -- enable LSP
    'williamboman/mason.nvim', -- simple to use language server installer
    'williamboman/mason-lspconfig.nvim',
    'tamago324/nlsp-settings.nvim', -- language server settings defined in json for
    'jose-elias-alvarez/null-ls.nvim', -- for formatters and linters
    'ray-x/lsp_signature.nvim',

    -- Programming languages
    'mfussenegger/nvim-jdtls', -- Java
    'simrat39/rust-tools.nvim', -- Rust
    'ray-x/go.nvim', -- Golang
    'ray-x/guihua.lua', -- recommended if need floating window support

    -- Debugging
    'mfussenegger/nvim-dap', -- debug adapter protocol
    'theHamsta/nvim-dap-virtual-text',
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap-python',
    'leoluz/nvim-dap-go', -- delve go debugger
    'mxsdev/nvim-dap-vscode-js',

    -- Testing
    --[[ { ]]
    --[[     'nvim-neotest/neotest', ]]
    --[[     requires = { ]]
    --[[         'nvim-lua/plenary.nvim', ]]
    --[[         'nvim-treesitter/nvim-treesitter', ]]
    --[[         'antoinemadec/FixCursorHold.nvim', ]]
    --[[         'nvim-neotest/neotest-go', ]]
    --[[         -- Your other test adapters here ]]
    --[[     }, ]]
    --[[     config = function() ]]
    --[[         -- get neotest namespace (api call creates or returns namespace) ]]
    --[[         local neotest_ns = vim.api.nvim_create_namespace('neotest') ]]
    --[[         vim.diagnostic.config({ ]]
    --[[             virtual_text = { ]]
    --[[                 format = function(diagnostic) ]]
    --[[                     local message = ]]
    --[[                         diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '') ]]
    --[[                     return message ]]
    --[[                 end, ]]
    --[[             }, ]]
    --[[         }, neotest_ns) ]]
    --[[         require('neotest').setup({ ]]
    --[[             -- your neotest config here ]]
    --[[             adapters = { ]]
    --[[                 require('neotest-go'), ]]
    --[[             }, ]]
    --[[         }) ]]
    --[[     end, ]]
    --[[ }) ]]

    -- Telescope
    'nvim-telescope/telescope.nvim',

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',

    -- Git
    'lewis6991/gitsigns.nvim',
    { 'NeogitOrg/neogit', dependencies = 'nvim-lua/plenary.nvim' },
    { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

    -- Discord presence
    'andweeb/presence.nvim',

    -- Org mode
    'nvim-orgmode/orgmode',

    -- SchemaStore
    'b0o/schemastore.nvim',

    -- Database
    'tpope/vim-dadbod',
    'kristijanhusak/vim-dadbod-ui',
    'kristijanhusak/vim-dadbod-completion',
}

require('lazy').setup(plugins, {})
