local Util = require 'core.utils'

core.handle = core.handle or {}

---@diagnostic disable duplicate-doc-alias

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
  ---@param event string
  ---@param ev? string
  setup = function (event, ev)
    ev = ev or event
    core.handle[ev] = core.handle[ev] or {}
    vim.api.nvim_create_autocmd(event, {
      group = core.group_id,
      desc = 'core handle for ' .. event,
      pattern = ev ~= event and ev or nil,
      ---@type AutoCmdCallback
      callback = function(opts)
        for i, fn_t in pairs(core.handle[ev]) do
          Util.log('autocmds.callback', string.format('autocmds:%s:%d', ev, i))
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
  --- handle.create {
  ---   event = 'custom', type = 'event', priority = 0,
  ---   fn = function() Util.log 'hi' end,
  --- }
  --- ```
  ---@param props { event: string, fn: AutoCmdCallback, priority?: integer, type?: string }
  create = function(props)
    if not props.event or not props.fn then
      return
    end

    local event = props.event
    local ev = props.event
    if event == 'custom' then
      event = 'User'
      ev = props.type
    end

    local priority = props.priority or 50

    if not core.handle[ev] then
      require 'core.load.handle'.setup (event, ev)
    end

    local current_handle = core.handle[ev][priority]
    if not current_handle then
      core.handle[ev][priority] = {}
      current_handle = core.handle[ev][priority]
    end
    core.handle[ev][priority][#current_handle+1] = props.fn
  end,
  --- trigger a custom event
  start = function(ev)
    Util.log('autocmds.setup', string.format('start:custom:%s', ev))
    vim.api.nvim_exec_autocmds('User', { pattern = ev })
  end,
}
