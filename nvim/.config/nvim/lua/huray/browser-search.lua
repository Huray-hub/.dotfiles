local my_utils = require('huray.my-utils')

--[[ my_utils.set_global_variable('browser_search_engines', )]]

--vim.cmd([[
--let g:browser_search_engines={
--  \ 'github':        'https://github.com/search?q=%s',
--  \ 'google':        'https://google.com/search?q=%s',
--  \ 'stackoverflow': 'https://stackoverflow.com/search?q=%s',
--  \ 'translate':     'https://translate.google.com/?sl=auto&tl=it&text=%s',
--  \ 'youtube':       'https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch',
--  \ }
--]])

my_utils.set_global_variable('browser_search_default_engine', 'google')
