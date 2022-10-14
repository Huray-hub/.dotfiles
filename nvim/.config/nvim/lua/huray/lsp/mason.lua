local status_ok, mason = pcall(require, 'mason')
if not status_ok then
    return
end

local servers = {
    'bashls',
    'clangd',
    'pyright',
    'jsonls',
    'jdtls',
    'sqls',
    'sumneko_lua',
    'yamlls',
    'omnisharp',
    'gopls',
    'rust_analyzer',
    'taplo',
    'asm_lsp',
}

local status_ok_1, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok_1 then
    return
end

local settings = {
    ui = {
        icons = {
            package_installed = '◍',
            package_pending = '◍',
            package_uninstalled = '◍',
        },
    },

    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status_ok then
    return
end

for _, server in pairs(servers) do
    local opts = {
        on_attach = require('huray.lsp.handlers').on_attach,
        capabilities = require('huray.lsp.handlers').capabilities,
    }

    server = vim.split(server, '@')[1]

    if server == 'jsonls' then
        local jsonls_opts = require('huray.lsp.settings.jsonls')
        opts = vim.tbl_deep_extend('force', jsonls_opts, opts)
    end

    if server == 'yamlls' then
        local yamlls_opts = require('huray.lsp.settings.yamlls')
        opts = vim.tbl_deep_extend('force', yamlls_opts, opts)
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

    if server == 'gopls' then
        local gopls_opts = require('huray.lsp.settings.gopls')
        opts = vim.tbl_deep_extend('force', gopls_opts, opts)
    end

    if server == 'jdtls' then
        goto continue
    end

    if server == 'rust_analyzer' then
        local rust_opts = require('huray.lsp.settings.rust')
        -- opts = vim.tbl_deep_extend("force", rust_opts, opts)
        local rust_tools_status_ok, rust_tools = pcall(require, 'rust-tools')
        if not rust_tools_status_ok then
            return
        end

        rust_tools.setup(rust_opts)
        goto continue
    end

    if server == 'ocaml-lsp' then
        local virtualtypes = require('virtualtypes')
        lspconfig.ocamllsp.setup({ on_attach = virtualtypes.on_attach })
    end

    lspconfig[server].setup(opts)
    ::continue::
end
