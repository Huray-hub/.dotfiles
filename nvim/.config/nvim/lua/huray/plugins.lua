local fn = vim.fn
local my_utils = require('huray.my-utils')
local command = my_utils.command

-- Automatically install packer
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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- TODO: refactor to lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

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
    use('wbthomason/packer.nvim') -- Have packer manage itself
    use('nvim-lua/popup.nvim') -- An implementation of the Popup API from vim in Neovim
    use('nvim-lua/plenary.nvim') -- Useful lua functions used ny lots of plugins
    use('windwp/nvim-autopairs') -- Autopairs, integrates with both cmp and treesitter
    use('numToStr/Comment.nvim') -- Easily comment stuff
    use('kyazdani42/nvim-web-devicons')
    use('kyazdani42/nvim-tree.lua')
    use('akinsho/bufferline.nvim')
    use('moll/vim-bbye')
    use('nvim-lualine/lualine.nvim')
    use('akinsho/toggleterm.nvim')
    use('ahmedkhalf/project.nvim')
    use('lewis6991/impatient.nvim')
    use('lukas-reineke/indent-blankline.nvim')
    use('goolord/alpha-nvim')
    use('antoinemadec/FixCursorHold.nvim') -- This is needed to fix lsp doc highlight
    use('folke/which-key.nvim')
    use({ 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' })
    use('kosayoda/nvim-lightbulb')
    use('filipdutescu/renamer.nvim')

    -- Colorschemes
    use('marko-cerovac/material.nvim')
    use('folke/tokyonight.nvim')
    use('lunarvim/darkplus.nvim')
    use('Mofiqul/dracula.nvim')
    use('navarasu/onedark.nvim')
    use('ellisonleao/gruvbox.nvim')
    use({ 'catppuccin/nvim', as = 'catppuccin' })
    use('Mofiqul/vscode.nvim')

    -- cmp plugins
    use('hrsh7th/nvim-cmp') -- The completion plugin
    use('hrsh7th/cmp-buffer') -- buffer completions
    use('hrsh7th/cmp-path') -- path completions
    use('hrsh7th/cmp-cmdline') -- cmdline completions
    use('saadparwaiz1/cmp_luasnip') -- snippet completions
    use('hrsh7th/cmp-nvim-lsp')
    use('rcarriga/cmp-dap') -- completion for dap buffers

    -- snippets
    use('L3MON4D3/LuaSnip') --snippet engine
    use('rafamadriz/friendly-snippets') -- a bunch of snippets to use

    -- LSP
    use('neovim/nvim-lspconfig') -- enable LSP
    use('williamboman/nvim-lsp-installer') -- simple to use language server installer
    use('tamago324/nlsp-settings.nvim') -- language server settings defined in json for
    use('jose-elias-alvarez/null-ls.nvim') -- for formatters and linters
    use('ray-x/lsp_signature.nvim')
    use({
        'rmagatti/goto-preview',
        -- config = function()
        --   require('goto-preview').setup {}
        -- end
    })

    -- Sessions
    use('Shatur/neovim-session-manager')

    -- Debugging
    use('mfussenegger/nvim-dap') -- debug adapter protocol
    use('theHamsta/nvim-dap-virtual-text')
    use('rcarriga/nvim-dap-ui')
    use('mfussenegger/nvim-dap-python')
    -- use("Pocco81/DAPInstall.nvim") -- debug adapter installer

    -- Java
    use('mfussenegger/nvim-jdtls')
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

    -- SQL
    use('nanotee/sqls.nvim')

    -- Competitive programming
    use('p00f/cphelper.nvim')

    -- Colors
    use('norcalli/nvim-colorizer.lua')

    -- Discord presence
    use('andweeb/presence.nvim')

    use({
        'abecodes/tabout.nvim',
        wants = { 'nvim-treesitter' }, -- or require if not used so far
        after = { 'nvim-cmp' }, -- if a completion plugin is using tabs load it before
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
