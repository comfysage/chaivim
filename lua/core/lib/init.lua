---@alias tuple<T> { [1]: T, [2]: T }

-- statically allocated instead of dynamically by function wrapping
---@class core.types.lib
---@field autocmd core.types.lib.autocmd
---@field event core.types.lib.event
---@field keymaps core.types.lib.keymaps
---@field hl core.types.lib.highlight
---@field options core.types.lib.options
---@field fmt core.types.lib.fmt
---@field color core.types.lib.color
---@field math core.types.lib.math

return {
  setup = function()
    ---@diagnostic disable-next-line: missing-fields
    core.lib = core.lib or {}
    require 'core.lib.preload'
    require 'core.lib.autocmd'
    require 'core.lib.event'
    require 'core.lib.keymaps'
    require 'core.lib.hl'
    require 'core.lib.fmt'

    ---@class core.types.lib
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
