local status_ok, alpha = pcall(require, 'alpha')
if not status_ok then
    return
end

local icons = require('huray.icons')

local dashboard = require('alpha.themes.dashboard')
dashboard.section.header.val = {
    [[ ██╗░░██╗██╗░░░██╗██████╗░░█████╗░██╗░░░██╗ ]],
    [[ ██║░░██║██║░░░██║██╔══██╗██╔══██╗╚██╗░██╔╝ ]],
    [[ ███████║██║░░░██║██████╔╝███████║░╚████╔╝░ ]],
    [[ ██╔══██║██║░░░██║██╔══██╗██╔══██║░░╚██╔╝░░ ]],
    [[ ██║░░██║╚██████╔╝██║░░██║██║░░██║░░░██║░░░ ]],
    [[ ╚═╝░░╚═╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░ ]],
}

dashboard.section.buttons.val = {
    dashboard.button('f', icons.documents.Files .. '  Find file', ':Telescope find_files <CR>'),
    dashboard.button('e', icons.ui.NewFile .. '  New file', ':ene <BAR> startinsert <CR>'),
    dashboard.button(
        'p',
        icons.git.Repo .. '  Find project',
        ":lua require('telescope').extensions.projects.projects()<CR>"
    ),
    dashboard.button('r', icons.ui.History .. '  Recent files', ':Telescope oldfiles <CR>'),
    dashboard.button('t', icons.ui.List .. '  Find text', ':Telescope live_grep <CR>'),
    dashboard.button('s', icons.ui.SignIn .. '  Find Session', ':Telescope sessions save_current=false <CR>'),
    dashboard.button('c', icons.ui.Gear .. '  Config', ':e ~/.dotfiles/nvim/.config/nvim/init.lua <CR>'),
    dashboard.button('q', icons.diagnostics.Error .. '  Quit', ':qa<CR>'),
}

dashboard.section.footer.val = 'Huray'

dashboard.section.footer.opts.hl = 'Type'
dashboard.section.header.opts.hl = 'Include'
dashboard.section.buttons.opts.hl = 'Keyword'

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
