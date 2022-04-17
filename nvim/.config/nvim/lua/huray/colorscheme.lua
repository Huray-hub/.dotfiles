local colorscheme = 'material'

local material_status_ok, material_colorscheme = pcall(require, colorscheme)
if material_status_ok then
  if colorscheme == 'material' then
    vim.api.nvim_set_var('material_style', 'palenight')

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
end

local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not status_ok then
  vim.notify('colorscheme ' .. colorscheme .. ' not found!')
  return
end
