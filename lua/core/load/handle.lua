local Util = require 'core.utils'

core.handle = core.handle or {}

---@alias AutoCmdCallback fun(ev: AutoCmdCallbackOpts)
---@class AutoCmdCallbackOpts
---@field id number autocommand id
---@field event string name of the triggered event `autocmd-events`
---@field group number|nil autocommand group id, if any
---@field match string expanded value of `<amatch>`
---@field buf number expanded value of `<abuf>`
---@field file string expanded value of `<afile>`
---@field data any arbitrary data passed from `nvim_exec_autocmds()`

return {
  setup = function (event)
    core.handle[event] = core.handle[event] or {}
    vim.api.nvim_create_autocmd(event, {
      group = core.group_id,
      desc = 'core handle for ' .. event,
      callback = function(opts)
        for i, fn_t in ipairs(core.handle[event]) do
          Util.log(string.format('autocmds:%s:%d', event, i))
          for _, fn in ipairs(fn_t) do
            fn(opts)
          end
        end
      end,
    })
  end,
  --- ```lua
  --- handle.create {
  ---   event = 'ColorScheme', priority = 0,
  ---   fn = function() Util.log 'hi' end,
  --- }
  --- ```
  ---@param props { event: string, fn: AutoCmdCallback, priority: integer|nil }
  create = function(props)
    if not props.event or not props.fn then
      return
    end

    local priority = props.priority or 50

    if not core.handle[props.event] then
      require 'core.load.handle'.setup (props.event)
    end

    local current_handle = core.handle[props.event][priority]
    if not current_handle then
      core.handle[props.event][priority] = {}
      current_handle = core.handle[props.event][priority]
    end
    core.handle[props.event][priority][#current_handle+1] = props.fn
  end
}
