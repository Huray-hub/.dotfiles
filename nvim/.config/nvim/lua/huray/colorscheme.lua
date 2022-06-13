local colorscheme = 'dracula'

local my_utils = require('huray.my-utils')
local set_global_variable = my_utils.set_global_variable
local command = my_utils.command

local material_setup = function(material_colorscheme)
    set_global_variable('material_style', 'deep ocean') -- 'oceanic'  'deep ocean' 'palenight' 'lighter' 'darker'

    material_colorscheme.setup({
        contrast = {
            sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
            floating_windows = false, -- Enable contrast for floating windows
            line_numbers = false, -- Enable contrast background for line numbers
            sign_column = false, -- Enable contrast background for the sign column
            cursor_line = false, -- Enable darker background for the cursor line
            non_current_windows = false, -- Enable darker background for non-current windows
            popup_menu = false, -- Enable lighter background for the popup menu
        },

        italics = {
            comments = false, -- Enable italic comments
            keywords = false, -- Enable italic keywords
            functions = false, -- Enable italic functions
            strings = false, -- Enable italic strings
            variables = false, -- Enable italic variables
        },

        contrast_filetypes = { -- Specify which filetypes get the contrasted (darker) background
            'terminal', -- Darker terminal background
            'packer', -- Darker packer background
            'qf', -- Darker qf list background
        },

        high_visibility = {
            lighter = false, -- Enable higher contrast text for lighter style
            darker = false, -- Enable higher contrast text for darker style
        },

        disable = {
            borders = false, -- Disable borders between verticaly split windows
            background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
            term_colors = false, -- Prevent the theme from setting terminal colors
            eob_lines = true, -- Hide the end-of-buffer lines
        },

        lualine_style = 'default', -- Lualine style ( can be 'stealth' or 'default' )

        custom_highlights = {
            LineNr = { fg = '#525262' }, -- #585863
        }, -- Overwrite highlights with your own
    })
end

local catppuccin_setup = function(catppuccin)
    set_global_variable('catppuccin_flavour', 'frappe') -- latte, frappe, macchiato, mocha

    catppuccin.setup({
        transparent_background = false,
        term_colors = false,
        styles = {
            comments = 'italic',
            conditionals = 'italic',
            loops = 'NONE',
            functions = 'NONE',
            keywords = 'NONE',
            strings = 'NONE',
            variables = 'NONE',
            numbers = 'NONE',
            booleans = 'NONE',
            properties = 'NONE',
            types = 'NONE',
            operators = 'NONE',
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = 'italic',
                    hints = 'italic',
                    warnings = 'italic',
                    information = 'italic',
                },
                underlines = {
                    errors = 'underline',
                    hints = 'underline',
                    warnings = 'underline',
                    information = 'underline',
                },
            },
            lsp_trouble = false,
            cmp = true,
            lsp_saga = false,
            gitgutter = false,
            gitsigns = true,
            telescope = true,
            nvimtree = {
                enabled = true,
                show_root = false,
                transparent_panel = false,
            },
            neotree = {
                enabled = false,
                show_root = false,
                transparent_panel = false,
            },
            which_key = false,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = false,
            },
            dashboard = true,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = true,
            markdown = true,
            lightspeed = false,
            ts_rainbow = false,
            hop = false,
            notify = true,
            telekasten = true,
            symbols_outline = true,
        },
    })
end

local status_ok, selected_colorscheme = pcall(require, colorscheme)
if status_ok then
    if selected_colorscheme == 'material' then
        material_setup(selected_colorscheme)
    elseif selected_colorscheme == 'catppuccin' then
        catppuccin_setup(selected_colorscheme)
    end
end

local colorscheme_ok, _ = pcall(command, 'colorscheme ' .. colorscheme)
if not colorscheme_ok then
    vim.notify('colorscheme ' .. selected_colorscheme .. ' not found!')
    return
end
