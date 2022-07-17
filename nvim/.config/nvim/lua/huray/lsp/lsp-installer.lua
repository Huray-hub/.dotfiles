local status_ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not status_ok then
    return
end

local servers = {
    'bashls',
    'clangd',
    'pyright',
    'jsonls',
    --"jdtls",
    'sqls',
    'sumneko_lua',
    'yamlls',
    'omnisharp',
    'gopls',
    'rust_analyzer',
}

local settings = {
    ensure_installed = servers,
    -- automatic_installation = false,
    ui = {
        icons = {
            -- server_installed = "◍",
            -- server_pending = "◍",
            -- server_uninstalled = "◍",
            -- server_installed = "✓",
            -- server_pending = "➜",
            -- server_uninstalled = "✗",
        },
        keymaps = {
            toggle_server_expand = '<CR>',
            install_server = 'i',
            update_server = 'u',
            check_server_version = 'c',
            update_all_servers = 'U',
            check_outdated_servers = 'C',
            uninstall_server = 'X',
        },
    },

    log_level = vim.log.levels.INFO,
    -- max_concurrent_installers = 4,
    -- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" },
}

lsp_installer.setup(settings) -- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).

local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status_ok then
    return
end

-- local opts = {}
local settings_path = 'huray.lsp.settings'

for _, server in pairs(servers) do
    local opts = {
        on_attach = require('huray.lsp.handlers').on_attach,
        capabilities = require('huray.lsp.handlers').capabilities,
    }

    if server == 'jsonls' then
        local jsonls_opts = require('huray.lsp.settings.jsonls')
        opts = vim.tbl_deep_extend('force', jsonls_opts, opts)
    end

    if server == 'sumneko_lua' then
        local sumneko_opts = require('huray.lsp.settings.sumneko_lua')
        opts = vim.tbl_deep_extend('force', sumneko_opts, opts)
    end

    if server == 'clangd' then
        local clangd_opts = require('huray.lsp.settings.clangd')
        opts = vim.tbl_deep_extend('force', clangd_opts, opts)
    end

    if server == 'pyright' then
        local pyright_opts = require('huray.lsp.settings.pyright')
        opts = vim.tbl_deep_extend('force', pyright_opts, opts)
    end

    if server == 'jdtls' then
        return
    end

    if server == 'gopls' then
        local gopls_opts = require('huray.lsp.settings.pyright')
        opts = vim.tbl_deep_extend('force', gopls_opts, opts)
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    lspconfig[server].setup(opts)
end
