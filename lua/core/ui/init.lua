local api = vim.api

---@class core.types.ui.model
---@field __index core.types.ui.model
---@field data table
---@field props core.types.ui.model.props
---@field internal core.types.ui.model.internal
local Model = {}

Model.__index = Model

---@class core.types.ui.model.props
---@field title? string

---@class core.types.ui.model.internal
---@field id integer
---@field ns integer
---@field buf integer
---@field win integer
---@field window { config: table, width: integer, height: integer }
---@field cmd 'quit'|any

---@class core.types.ui.model
---@field new fun(self: core.types.ui.model, data: table, props?: core.types.ui.model.props): core.types.ui.model
function Model:new(data, props)
  local ns = api.nvim_create_namespace ''
  local model = setmetatable({
    data = data,
    props = props or {},
    internal = {
      id = api.nvim_create_augroup(('core.ui[%d]'):format(ns), {}),
      ns = ns, -- anonymous ns
      buf = 0,
      win = 0,
      window = { config = {}, width = 0, height = 0 },
      cmd = nil,
    },
  }, self)

  return model
end

---@class core.types.ui.model
---@field _init fun(self: core.types.ui.model)
function Model:_init()
  self.internal.buf = api.nvim_create_buf(false, true)

  -- open window
  self.internal.window.height = api.nvim_win_get_height(0)
  self.internal.window.width = vim.o.columns

  self.internal.window.config = {
    relative = 'editor',
    title = self.props.title or '',
    title_pos = 'center',
    border = 'rounded',
    row = 1,
    col = 1,
    width = 1,
    height = 1,
    hide = true,
  }

  self.internal.win =
      api.nvim_open_win(self.internal.buf, false, self.internal.window.config)

  api.nvim_win_set_buf(self.internal.win, self.internal.buf)

  local name = self.props.title and 'core.' .. self.props.title or 'core'
  vim.opt_local.filetype = name
  vim.g[name .. '_displayed'] = true

  vim.keymap.set('n', 'q', function()
    self:send 'quit'
  end, { buffer = self.internal.buf })

  -- buf only options
  api.nvim_set_option_value('modifiable', false, { buf = self.internal.buf })
  api.nvim_set_option_value('buflisted', false, { buf = self.internal.buf })

  api.nvim_set_option_value('number', false, { win = self.internal.win })
  api.nvim_set_option_value(
    'relativenumber',
    false,
    { win = self.internal.win }
  )
  api.nvim_set_option_value('signcolumn', 'no', { win = self.internal.win })
  api.nvim_set_option_value('list', false, { win = self.internal.win })
  api.nvim_set_option_value('wrap', false, { win = self.internal.win })
  api.nvim_set_option_value('cul', false, { win = self.internal.win })
  api.nvim_set_option_value('colorcolumn', '0', { win = self.internal.win })

  self.internal.window.config.hide = false
  api.nvim_set_current_win(self.internal.win)
  self:send 'winresize'

  api.nvim_create_autocmd({ 'QuitPre', 'BufDelete' }, {
    buffer = self.internal.buf,
    group = self.internal.id,
    callback = function()
      api.nvim_del_augroup_by_id(self.internal.id)
    end,
  })
  api.nvim_create_autocmd('WinResized', {
    group = self.internal.id,
    callback = function()
      self:send 'winresize'
    end,
  })
end

---@class core.types.ui.model
---@field _view fun(self: core.types.ui.model): string
function Model:_view()
  local lines = self:view()
  api.nvim_set_option_value('modifiable', true, { buf = self.internal.buf })
  api.nvim_buf_set_lines(self.internal.buf, 0, -1, false, lines)
  api.nvim_set_option_value('modifiable', false, { buf = self.internal.buf })
end

---@class core.types.ui.model
---@field _update fun(self: core.types.ui.model, msg): any
function Model:_update(msg)
  self:update(msg)

  return msg
end

---@class core.types.ui.model
---@field init fun(self: core.types.ui.model)
function Model:init() end

---@class core.types.ui.model
---@field view fun(self: core.types.ui.model)
function Model:view() end

---@class core.types.ui.model
---@field update fun(self: core.types.ui.model, msg)
function Model:update(_) end

--- used to respond to data changes
---@class core.types.ui.model
---@field send fun(self: core.types.ui.model, msg)
function Model:send(msg)
  self.internal.cmd = self:_update(msg)

  local fn = {
    quit = function()
      api.nvim_del_augroup_by_id(self.internal.id)
      api.nvim_buf_delete(self.internal.buf, { force = true })
    end,
    view = function()
      return self:_view()
    end,
    winresize = function()
      self.internal.window.height = api.nvim_win_get_height(1000)
      self.internal.window.width = vim.o.columns

      local _height = math.floor(self.internal.window.height * 0.8)
      local _width = 90
      _width = _width > self.internal.window.width
          and self.internal.window.width
          or _width

      self.internal.window.config.row =
          math.floor((self.internal.window.height - _height) / 2)
      self.internal.window.config.col =
          math.floor((self.internal.window.width - _width) / 2)
      self.internal.window.config.width = _width
      self.internal.window.config.height = _height

      api.nvim_win_set_config(self.internal.win, self.internal.window.config)
    end,
  }

  if type(self.internal.cmd) ~= 'table' then
    if self.internal.cmd == nil then
      self.internal.cmd = 'view'
    end
    self.internal.cmd = { self.internal.cmd }
  end
  for _, cmd in ipairs(self.internal.cmd) do
    local _fn = fn[cmd]
    if not _fn then
      _fn = fn.view
    end
    _fn()
  end
end

---@class core.types.ui.model
---@field open fun(self: core.types.ui.model)
function Model:open()
  self:init()
  self:_init()

  self:send(nil)
end

return function(...)
  return Model:new(...)
end
