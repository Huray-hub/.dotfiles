local status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
    vim.notify('trouble ' .. trouble .. ' not found!')
    return
end

local icons = require('huray.icons')

trouble.setup({
    mode = 'workspace_diagnostics', -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    signs = {
        error = icons.diagnostics.BoldError,
        warning = icons.diagnostics.BoldWarning,
        hint = icons.diagnostics.BoldHint,
        information = icons.diagnostics.BoldInformation,
        other = icons.diagnostics.BoldQuestion,
    },
    use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
})
