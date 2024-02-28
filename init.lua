-- bootstrap chaivim
local rootpath = vim.fn.stdpath('data') .. '/core'
local chaipath = rootpath .. '/chai'

if not vim.loop.fs_stat(chaipath) then
  vim.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/comfysage/chaivim.git',
    chaipath,
  }):wait()
end
vim.opt.rtp:prepend(chaipath)

require 'core'.setup 'custom'
