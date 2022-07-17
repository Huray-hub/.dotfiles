local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
    return
end

configs.setup({
    ensure_installed = 'all', -- one of 'all' or a list of languages
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { '' }, -- List of parsers to ignore installing
    highlight = {
        -- user_languagetree = true,
        enable = true, -- false will disable the whole extension
        disable = { 'css', 'markdown' }, -- list of language that will be disabled
        additional_vim_regex_highlighting = true,
    },
    autopairs = {
        enable = true,
    },
    indent = { enable = true, disable = { 'yaml', 'css' } },
    context_commentstring = {
        enable = true,
        ensure_installed = false,
    },
    autotag = {
        enable = true,
        disable = { 'xml' },
    },
    rainbow = {
        enable = true,
        colors = {
            'Gold',
            'Orchid',
            'DodgerBlue',
            -- "Cornsilk",
            -- "Salmon",
            -- "LawnGreen",
        },
        disable = { 'html' },
    },
    playground = {
        enable = true,
    },
})
