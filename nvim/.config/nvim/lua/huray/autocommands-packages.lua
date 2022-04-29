-- Here there are autocommands related to installed programs
local my_utils = require('huray.my-utils')

local augroup = my_utils.augroup
local autocmd = my_utils.autocmd

local _Xresources = augroup('_Xresources', {})
autocmd('BufWritePost', {
  desc = 'Run xrdb whenever Xresources are updated',
  group = _Xresources,
  pattern = '*Xresources',
  command = '!xrdb %',
})

local _sxhkd = augroup('_sxhkd', {})
autocmd('BufWritePost', {
  desc = 'Update binds when sxhkdrc is updated',
  group = _sxhkd,
  pattern = '*sxhkdrc',
  command = '!killall sxhkd; setsid sxhkd &',
})

local _dunst = augroup('_augroup', {})
autocmd('BufWritePost', {
  desc = 'Reload dunst when dunstrc is updated',
  group = _dunst,
  pattern = '*dunstrc',
  command = '!killall dunst;',
})
