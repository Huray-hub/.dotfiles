-- Here there are autocommands related to installed programs
local my_utils = require('huray.my-utils')

local augroup = my_utils.augroup
local autocmd = my_utils.autocmd

local _Xresources = augroup('_Xresources', {})
autocmd('BufWritePost', {
    desc = 'Run xrdb on Xresources save',
    group = _Xresources,
    pattern = '*Xresources',
    command = '!xrdb %',
})

local _sxhkd = augroup('_sxhkd', {})
autocmd('BufWritePost', {
    desc = 'Update binds on sxhkdrc save',
    group = _sxhkd,
    pattern = '*sxhkdrc',
    command = '!killall sxhkd; setsid sxhkd &',
})

local _dunst = augroup('_dunst', {})
autocmd('BufWritePost', {
    desc = 'Reload dunst on dunstrc save',
    group = _dunst,
    pattern = '*dunstrc',
    command = '!killall dunst; dunst &',
})

local _picom = augroup('_picom', {})
autocmd('BufWritePost', {
    desc = 'Reload picom on picom.conf save',
    group = _picom,
    pattern = '*picom.conf',
    command = '!killall picom; picom -b',
})
