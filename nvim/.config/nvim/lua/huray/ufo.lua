local status_ok, ufo = pcall(require, 'ufo')
if not status_ok then
    return
end

ufo.setup({
    open_fold_hl_timeout = {
        description = [[Time in millisecond between the range to be highlgihted and to be cleared
                    while opening the folded line, `0` value will disable the highlight]],
        default = 400
    },
    provider_selector = {
        description = [[A function as a selector for fold providers. For now, there are
                    'lsp' and 'treesitter' as main provider, 'indent' as fallback provider]],
        default = nil
    },
    close_fold_kinds = {
        description = [[After the buffer is displayed (opened for the first time), close the
                    folds whose range with `kind` field is included in this option.
                    For now, only 'lsp' provider contain 'comment', 'imports' and 'region'.]],
        default = {}
    },
    fold_virt_text_handler = {
        description = [[A function customize fold virt text, see ### Customize fold text]],
        default = nil
    },
    enable_get_fold_virt_text = {
        description = [[Enable a function with `lnum` as a parameter to capture the virtual text
                    for the folded lines and export the function to `get_fold_virt_text` field of
                    ctx table as 6th parameter in `fold_virt_text_handler`]],
        default = false
    },
    preview = {
        description = [[Configure the options for preview window and remap the keys for current
                    buffer and preview buffer if the preview window is displayed.
                    Never worry about the users's keymaps are overridden by ufo, ufo will save
                    them and restore them if preview window is closed.]],
        win_config = {
            border = {
                description = [[The border for preview window,
                    `:h nvim_open_win() | call search('border:')`]],
                default = 'rounded',
            },
            winblend = {
                description = [[The winblend for preview window, `:h winblend`]],
                default = 12,
            },
            winhighlight = {
                description = [[The winhighlight for preview window, `:h winhighlight`]],
                default = 'Normal:Normal',
            },
            maxheight = {
                description = [[The max height of preview window]],
                default = 20,
            }
        },
        mappings = {
            description = [[The table for {function = key}]],
            default = [[see ###Preview function table for detail]],
        }
    }
})
