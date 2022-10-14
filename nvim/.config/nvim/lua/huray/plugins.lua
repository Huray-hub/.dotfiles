local my_utils = require('huray.my-utils')
local command = my_utils.command

-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    print('Installing packer close and reopen Neovim...')
    command('packadd packer.nvim')
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'rounded' })
        end,
    },
})

-- Install your plugins here
return packer.startup(function(use)
    -- General
    use('wbthomason/packer.nvim') -- Have packer manage itself
    use('nvim-lua/popup.nvim') -- An implementation of the Popup API from vim in Neovim
    use('nvim-lua/plenary.nvim') -- Useful lua functions used ny lots of plugins
    use('kyazdani42/nvim-web-devicons')
    use('kyazdani42/nvim-tree.lua')
    use('akinsho/bufferline.nvim')
    use('moll/vim-bbye')
    use('nvim-lualine/lualine.nvim')
    use('akinsho/toggleterm.nvim')
    use('ahmedkhalf/project.nvim')
    use('lewis6991/impatient.nvim')
    use('goolord/alpha-nvim')
    use('folke/which-key.nvim')
    use({ 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' })
    use('kosayoda/nvim-lightbulb')

    -- Convenience
    use('kylechui/nvim-surround') -- Surround text-objects with letters
    use('voldikss/vim-browser-search') -- Open Urls to Browser
    use('norcalli/nvim-colorizer.lua') -- Colors on hex codes
    use({ -- Pass through parentheses with tabs
        'abecodes/tabout.nvim',
        wants = { 'nvim-treesitter' }, -- or require if not used so far
        after = { 'nvim-cmp' }, -- if a completion plugin is using tabs load it before
    })
    use('Shatur/neovim-session-manager') -- Session support
    use('windwp/nvim-autopairs') -- Autopairs, integrates with both cmp and treesitter
    use('numToStr/Comment.nvim') -- Easily comment stuff
    use('lukas-reineke/indent-blankline.nvim')
    use('RRethy/vim-illuminate')
    use('filipdutescu/renamer.nvim')

    -- Colorschemes
    use('marko-cerovac/material.nvim')
    use('folke/tokyonight.nvim')
    use('lunarvim/darkplus.nvim')
    use('Mofiqul/dracula.nvim')
    use('navarasu/onedark.nvim')
    use('ellisonleao/gruvbox.nvim')
    use('Mofiqul/vscode.nvim')

    -- Cmp plugins
    use('hrsh7th/nvim-cmp') -- The completion plugin
    use('hrsh7th/cmp-buffer') -- buffer completions
    use('hrsh7th/cmp-path') -- path completions
    use('hrsh7th/cmp-cmdline') -- cmdline completions
    use('saadparwaiz1/cmp_luasnip') -- snippet completions
    use('hrsh7th/cmp-nvim-lsp')
    use('rcarriga/cmp-dap') -- completion for dap buffers

    -- Snippets
    use('L3MON4D3/LuaSnip') --snippet engine
    use('rafamadriz/friendly-snippets') -- a bunch of snippets to use

    -- LSP
    use('neovim/nvim-lspconfig') -- enable LSP
    use('williamboman/mason.nvim') -- simple to use language server installer
    use('williamboman/mason-lspconfig.nvim')
    use('tamago324/nlsp-settings.nvim') -- language server settings defined in json for
    use('jose-elias-alvarez/null-ls.nvim') -- for formatters and linters
    use('ray-x/lsp_signature.nvim')

    -- Programming languages
    use('mfussenegger/nvim-jdtls') -- Java
    use('simrat39/rust-tools.nvim') -- Rust
    use('ray-x/go.nvim') -- Golang
    use('ray-x/guihua.lua') -- recommended if need floating window support
    use('nanotee/sqls.nvim') -- SQL

    -- Debugging
    use('mfussenegger/nvim-dap') -- debug adapter protocol
    use('theHamsta/nvim-dap-virtual-text')
    use('rcarriga/nvim-dap-ui')
    use('mfussenegger/nvim-dap-python')
    use('leoluz/nvim-dap-go') -- delve go debugger

    -- Telescope
    use('nvim-telescope/telescope.nvim')

    -- Treesitter
    use({
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    })
    use('JoosepAlviste/nvim-ts-context-commentstring')

    -- Git
    use('lewis6991/gitsigns.nvim')

    -- Discord presence
    use('andweeb/presence.nvim')

    -- Org mode
    use('nvim-orgmode/orgmode')

    -- Virtual text on types
    use('jubnzv/virtual-types.nvim')

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
