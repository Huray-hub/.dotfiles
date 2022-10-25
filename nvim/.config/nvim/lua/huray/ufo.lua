local status_ok, ufo = pcall(require, 'ufo')
if not status_ok then
    return
end

-- defaults for now
ufo.setup()

-- nvim ufo
local my_utils = require('huray.my-utils')
local keymap = my_utils.keymap
keymap('n', 'zR', require('ufo').openAllFolds)
keymap('n', 'zM', require('ufo').closeAllFolds)
