local notes_buf, notes_win, cursor_pos

local function open_win()
    notes_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(notes_buf, 'bufhidden', 'wipe')

    local width = vim.api.nvim_get_option('columns')
    local height = vim.api.nvim_get_option('lines')

    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.6)

    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    --[[ local width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 20))) ]]
    --[[ local height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10))) ]]
    --[[]]
    --[[ width = vim.F.if_nil(M._resolve_size(opts.width, term), width) ]]
    --[[ height = vim.F.if_nil(M._resolve_size(opts.height, term), height) ]]
    --[[]]
    --[[ local row = math.ceil(vim.o.lines - height) * 0.5 - 1 ]]
    --[[ local col = math.ceil(vim.o.columns - width) * 0.5 - 1 ]]

    local opts = {
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = 'rounded',
    }

    notes_win = vim.api.nvim_open_win(notes_buf, true, opts)
end

local function view()
    --[[ vim.api.nvim_buf_set_option(buf, 'modifiable', true) ]]
    local file_path = vim.fn.glob('/home/panos/Mega/org/notes.md')
    vim.api.nvim_command('edit ' .. file_path)
    vim.api.nvim_buf_set_option(notes_buf, 'bufhidden', 'wipe')
end

local function open_org()
    open_win()
    view()
end

local function toggle_org()
    if notes_buf ~= nil and vim.api.nvim_buf_is_loaded(notes_buf) then
        cursor_pos = vim.api.nvim_win_get_cursor(notes_win)
        --[[ vim.api.nvim_buf_call(buf, 'write') ]]
        --[[ vim.api.nvim_buf_call(buf, vim.api.nvim_command_output('write')) ]]
        vim.api.nvim_win_close(notes_win, false)
    else
        open_org()
        if cursor_pos ~= nil then
            vim.api.nvim_win_set_cursor(notes_win, cursor_pos)
        end
    end
end

return {
    open_org = open_org,
    toggle_org = toggle_org,
}
