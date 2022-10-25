local status_ok, my_utils = pcall(require,'huray.my-utils')
if not status_ok then
    return
end

local buf_keymap = my_utils.buf_keymap

buf_keymap('n', '<F5>', '<Plug>(sqls-execute-query)')
buf_keymap('v', '<F5>', '<Plug>(sqls-execute-query)')
