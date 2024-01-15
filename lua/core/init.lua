require 'core.load'
require 'core.plugin.globals'

local Util = require 'core.utils'
local parts = require 'core.parts'

---@diagnostic disable duplicate-doc-alias

---@alias MainModule 'core'|'config'|string

---@class ModuleSpec
---@field name ModuleName
---@field event string
---@field opts table|string|nil
---@field reload boolean

---@alias ModuleName 'options'|'highlights'|'base'|'maps'|'plugins'|string
---@alias ModuleField { [MainModule]: ModuleSpec[] }

---@class Config
---@field log_level integer
---@field colorscheme string
---@field transparent_background boolean
---@field config_module string
---@field modules Modules

---@class Core
---@field config Config
---@field group_id integer
---@field path CorePath
---@field loaded boolean
---@field modules InternalModules parsed module configs
---@field lib core.types.lib

---@class core.types.lib
---@field icons CoreIcons
---@field hl CoreHighlights
--- ... `core.lib`

---@class CorePath
---@field root string
---@field core string
---@field lazy string
---@field log string

---@alias InternalModules { [MainModule]: { [ModuleName]: ModuleSpec } }

local M = {}

---@type Core
---@diagnostic disable: missing-fields
_G.core = _G.core or {}

---@type Config
M.default_config = {
  log_level = vim.log.levels.INFO,
  colorscheme = 'evergarden', -- or 'habamax' or 'zaibatsu' or 'retrobox'
  transparent_background = false,
  modules = {},
}

---@type Config
_G.core.config = vim.tbl_deep_extend('force', M.default_config, _G.core.config or {})

local root_path = vim.fn.stdpath("data") .. "/core"
_G.core.path = {
  root = root_path,
  log = ('%s/core_log.txt'):format(vim.fn.stdpath("data")),
}
_G.core.path.core = _G.core.path.root .. "/chai"

_G.core.modules = _G.core.modules or {}

---@param config Config
function M.setup(config)
  if type(config) == 'string' then
    local status, opts = SR(config)
    if not status then
      Util.log('core.setup', 'config module ' .. config .. ' was not found', 'error')
      return
    end
    if type(opts) == 'table' then
      M.setup(opts)
    end
    return
  end
  CONFIG_MODULE = config.config_module or 'custom'

  -- preload keymaps module
  parts.preload {}

  ---@class Config
  local _config = {
    colorscheme = config.colorscheme,
    transparent_background = config.transparent_background,
    config_module = CONFIG_MODULE,
    modules = config.modules,
  }

  _G.core.config = vim.tbl_deep_extend('force', _G.core.config, _config)

  M.load()
end

--- load config
function M.load()
  if core.loaded then
    M.reload()
    return
  end

  Util.log('core.startup', 'loading config')

  if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end
  core.group_id = vim.api.nvim_create_augroup('core:' .. CONFIG_MODULE, {})
  require 'core.load.autocmds'.setup {
    group_id = core.group_id,
  }

  parts.load_modules {}

  parts.colorscheme {}

  parts.load_transparency {}

  parts.platform {}

  core.loaded = true
end

function M.reload()
  Util.log('core.reload', 'reloading config')

  vim.api.nvim_del_augroup_by_id(core.group_id)
  core.group_id = vim.api.nvim_create_augroup("config:" .. CONFIG_MODULE, {})
  require 'core.load.autocmds'.setup {
    group_id = core.group_id,
  }

  parts.load_modules {}

  parts.colorscheme {}

  parts.load_transparency {}

  parts.platform {}

  vim.api.nvim_exec_autocmds('ColorScheme', {})
end

function M.update()
  parts.update_core {}
  parts.update_keymaps {}
end

return M
