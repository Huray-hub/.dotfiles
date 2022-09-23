-- Load custom tree-sitter grammar for org filetype

local status_ok, orgmode = pcall(require, 'orgmode')
if not status_ok then
    return
end

orgmode.setup_ts_grammar()

orgmode.setup({
    org_agenda_files = '~/Mega/org/*',
    org_default_notes_file = '~/Mega/org/notes.org',
})
