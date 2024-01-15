---@class core.types.lib.options
core.lib.options = core.lib.options or {}
core.lib.options.__value = core.lib.options.__value or {}

---@class core.types.lib.options
---@field get fun(self, ...: string): any
function core.lib.options:get(name, ...)
  if not name then return end
  local query = { ... }
  if #query == 0 then return end
  local module = self.__value[name]
  if module and type(module.opts) == 'table' then
    ---@diagnostic disable-next-line: param-type-mismatch
    return vim.tbl_get(module.opts, ...)
  end
end
