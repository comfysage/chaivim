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
---@field cursor tuple<integer>
---@field hls { [string]: table<core.types.ui.model.internal.hl_pos> }

---@alias core.types.ui.model.internal.hl_pos { [1]: integer, [2]: integer, [3]: integer }

---@class core.types.ui.model
---@field new fun(self: core.types.ui.model, data: table, props?: core.types.ui.model.props): core.types.ui.model
function Model:new(data, props)
  local model = setmetatable({
    data = data,
    props = props or {},
    internal = {
      id = '',
      ns = 0,
      buf = 0,
      win = 0,
      window = { config = {}, width = 0, height = 0 },
      cmd = nil,
      cursor = { 0, 0 },
      hls = {},
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
  api.nvim_create_autocmd('CursorMoved', {
    group = self.internal.id,
    buffer = self.internal.buf,
    callback = function()
      self:send 'cursormove'
    end,
  })
end

---@class core.types.ui.model
---@field add_mapping fun(self: core.types.ui.model, mode, lhs, msg)
---@param mode string
---@param lhs string
---@param msg string
function Model:add_mapping(mode, lhs, msg)
  vim.keymap.set(mode, lhs, function()
    self:send(msg)
  end, {
      desc = ('coreui:%s'):format(msg),
      buffer = self.internal.buf,
      silent = true,
    })
end

---@class core.types.ui.model
---@field _view fun(self: core.types.ui.model)
function Model:_view()
  self.internal.hls = {}

  local lines = self:view()
  api.nvim_set_option_value('modifiable', true, { buf = self.internal.buf })
  api.nvim_buf_set_lines(self.internal.buf, 0, -1, false, lines)
  api.nvim_set_option_value('modifiable', false, { buf = self.internal.buf })

  self:send 'hls'
end

---@class core.types.ui.model
---@field add_hl fun(self: core.types.ui.model, name: string, ...)
function Model:add_hl(name, ...)
  self.internal.hls[name] = self.internal.hls[name] or {}
  self.internal.hls[name][#self.internal.hls[name] + 1] = { ... }
end

---@class core.types.ui.model
---@field _update fun(self: core.types.ui.model, msg: string): any
function Model:_update(msg)
  local _msg = self:update(msg)
  if type(msg) ~= 'table' then
    msg = { msg }
  end
  if type(_msg) ~= 'table' then
    _msg = { _msg }
  end

  return { unpack(msg), unpack(_msg) }
end

---@class core.types.ui.model
---@field init fun(self: core.types.ui.model)
function Model:init() end

---@class core.types.ui.model
---@field view fun(self: core.types.ui.model)
function Model:view() end

---@class core.types.ui.model
---@field update fun(self: core.types.ui.model, msg)
---@param _ string
function Model:update(_) end

--- used to respond to data changes
---@class core.types.ui.model
---@field send fun(self: core.types.ui.model, msg)
---@param msg string
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
    cursormove = function()
      self.internal.cursor = api.nvim_win_get_cursor(self.internal.win)
    end,
    hls = function()
      for name, hl_items in pairs(self.internal.hls) do
        for _, v in ipairs(hl_items) do
          local y, x_start, x_end = unpack(v, 1, 3)
          api.nvim_buf_add_highlight(
            self.internal.buf,
            0,
            'Core' .. name,
            y - 1,
            x_start,
            x_end
          )
        end
      end
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
  -- anonymous ns
  local ns = api.nvim_create_namespace ''
  self.internal.ns = ns
  self.internal.id = api.nvim_create_augroup(('core.ui[%d]'):format(ns), {})
  self:_init()
  self:init()

  self:send(nil)
end

return function(...)
  return Model:new(...)
end
