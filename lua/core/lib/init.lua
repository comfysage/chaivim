return {
  setup = function()
    core.lib = {}
    require 'core.plugin.icons'.setup()
    require 'core.plugin.hl'.setup()

    -- statically allocated instead of dynamically by function wrapping
    ---@class CoreLib
    ---@field autocmd CoreLib__autocmd
    ---@field event CoreLib__event
    ---@field keymaps CoreLib__keymaps

    ---@class CoreLib__autocmd
    ---@field create _
    core.lib.autocmd = {}
    core.lib.autocmd.create = require 'core.load.handle'.create

    ---@class CoreLib__event
    ---@field trigger fun(ev: string)
    core.lib.event = {}
    core.lib.event.trigger = require 'core.load.handle'.start

    ---@class CoreLib__keymaps
    ---@field fmt fun(lhs: string): string
    core.lib.keymaps = {}
    core.lib.keymaps.fmt = require 'core.plugin.keymaps'.fmt
  end,
}
