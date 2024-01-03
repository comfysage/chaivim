-- statically allocated instead of dynamically by function wrapping
---@class CoreLib
---@field autocmd CoreLib__autocmd
---@field event CoreLib__event
---@field keymaps CoreLib__keymaps
---@field hl CoreLib__highlight
---@field color CoreLib__color
---@field math CoreLib__math

return {
  setup = function()
    ---@diagnostic disable-next-line: missing-fields
    core.lib = {}
    require 'core.lib.preload'
    require 'core.lib.autocmd'
    require 'core.lib.event'
    require 'core.lib.keymaps'
    require 'core.lib.hl'

    ---@class CoreLib
    ---@field get fun(field: string, ...: string): any
    function core.lib:get(field, ...)
      local query_fn = {
        ---@type fun(...: string): Keymap
        keymaps = function(...) return vim.tbl_get(keymaps, 'prototype', ...) end
      }
      local fn = query_fn[field]
      if fn and type(fn) == 'function' then
        return fn(...)
      end
      if core.lib[field] and core.lib[field].get then
        return core.lib[field]:get(...)
      end
      return nil
    end

    setmetatable(core.lib,
      {
        __call = core.lib.get,
      })
  end,
}
