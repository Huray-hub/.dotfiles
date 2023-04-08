vim.cmd([[
    " nnoremap <silent> <leader>du :DBUIToggle<CR>
    " nnoremap <silent> <leader>df :DBUIFindBuffer<CR>
    " nnoremap <silent> <leader>dr :DBUIRenameBuffer<CR>
    " nnoremap <silent> <leader>dl :DBUILastQueryInfo<CR>
    let g:db_ui_save_location = '~/.config/db_ui'


    autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni

    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

    " Source is automatically added, you just need to include it in the chain complete list
    " let g:completion_chain_complete_list = {
    "     \   'sql': [
    "     \    {'complete_items': ['vim-dadbod-completion']},
    "     \   ],
    "     \ }

    " Make sure `substring` is part of this list. Other items are optional for this completion source
    let g:completion_matching_strategy_list = ['exact', 'substring']

    " Useful if there's a lot of camel case items
    let g:completion_matching_ignore_case = 1
]])
