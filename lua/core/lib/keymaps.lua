---@class core.types.lib.keymaps
---@field fmt fun(lhs: string): string
core.lib.keymaps = {}
core.lib.keymaps.fmt = require 'core.plugin.keymaps'.fmt

---@class core.types.lib.keymaps
---@field open_qf_list function
core.lib.keymaps.open_qf_list = function()
  if core.lib.options:enabled 'trouble' then
    require("trouble").toggle("quickfix")
  else
    vim.cmd.copen()
  end
end
