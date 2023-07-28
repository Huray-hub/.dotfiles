local status_ok, incline = pcall(require, 'incline')
if not status_ok then
    vim.notify('incline ' .. incline .. ' not found!')
    return
end

incline.setup({
    hide = {
        cursorline = true,
    },
    render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        if bufname == '' then
            return '[No name]'
        else
            return {
                vim.fn.fnamemodify(bufname, ':.'),
            }
        end
    end,
})
