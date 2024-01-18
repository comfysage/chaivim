---@class core.types.lib.highlight
---@field apply fun(hls: HLGroups )
core.lib.hl = core.lib.hl or {}
core.lib.hl.apply = require 'core.plugin.highlight'.apply

---@class core.types.lib.highlight
---@field get_hl fun(props: { name: string }): core.types.hl.highlight
core.lib.hl.get_hl = function(props)
  return vim.api.nvim_get_hl(0, props)
end

---@class core.types.lib.highlight
---@field get fun(self, ...: string): integer
function core.lib.hl:get(...)
  return vim.tbl_get(self.__value, ...)
end
