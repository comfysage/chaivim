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

---@class core.types.lib.keymaps
---@field register_qf_loader fun(key: string, cb: function, opts: { handle_open?: boolean })
--- *opts*
--- - *handle_open*: if true cb is wrapped in a fn that opens the qf list
core.lib.keymaps.register_qf_loader = function(key, cb, opts)
  if core.modules.core.keymaps.opts.qf_loaders[key] then return end
  if opts.handle_open then
    local _cb = vim.schedule_wrap(cb)
    cb = function()
      _cb()
      core.lib.keymaps.open_qf_list()
    end
  end
  core.modules.core.keymaps.opts.qf_loaders[key] = cb
end
