local Util = require 'core.utils'

local parts = {}

function parts.load_modules(_)
  if not core.config.modules['core'] then
    Util.log('core modules are not defined.', 'error')
    return
  end

  for main_mod, modules in pairs(core.config.modules) do
    -- if main_mod == 'core' then
    --   goto continue
    -- end
    Util.log('loading ' .. main_mod .. ' modules.')

    parts._modules(main_mod, modules)

    -- ::continue::
  end
end

---@param module string
---@param spec ModuleSpec
function parts.load(module, spec)
  if spec.loaded and spec.reload == false then
    Util.log('skipping reloading module: ' .. module)
    return
  end

  ---@param source string
  ---@param opts table
  local callback = function(source, opts)
    local status, result = pcall(require, source)
    if not status then
      Util.log("failed to load " .. source .. "\n\t" .. result, 'error')
      return
    end
    if type(result) == 'table' then
      if result.setup then
        result.setup(opts)
      end
    end
  end

  if spec.event then
    vim.api.nvim_create_autocmd({ spec.event }, {
      group = core.group_id,
      once = true,
      callback = function()
        callback(module, spec.opts)
      end,
    })
  else
    callback(module, spec.opts)
  end
end

---@param modules { [ModuleName]: boolean }
function parts._modules(mod, modules)
  for _, spec in ipairs(modules) do
    ---@type ModuleName
    local module = mod .. '.' .. spec.name
    if mod == 'core' then
      module = mod .. '.config.' .. spec.name
    end

    parts.load(module, spec)
    spec.loaded = true
  end
end

function parts.colorscheme(_)
  vim.cmd.colorscheme(core.config.colorscheme)
  local ok, _ = pcall(vim.cmd.colorscheme, core.config.colorscheme)
  if not ok then
    Util.log("couldn't load colorscheme", 'error')
  end

  vim.api.nvim_create_autocmd({ 'UIEnter' }, {
    group = core.group_id,
    once = true,
    callback = function()
      vim.api.nvim_exec_autocmds('ColorScheme', {})
    end
  })
end

function parts.preload(_)
  core.path.keymaps = core.path.root .. "/keymaps"
  vim.opt.rtp:prepend(core.path.keymaps)

  local ok, keymaps_nvim = pcall(require, 'keymaps')
  if ok then
    keymaps_nvim.setup {}
  else
    Util.log 'module keymaps not found. bootstrapping...'
    keymaps_nvim = require 'core.bootstrap'.load 'keymaps'
    if not keymaps_nvim then
      Util.log('error while bootstrapping.', 'error')
      return
    end
    keymaps_nvim.setup {}
  end

  if not keymaps then
    Util.log('global keymaps is not defined.', 'error')
    return
  end
end

function parts.platform(_)
  local has = vim.fn.has
  local is_mac = has 'macunix'
  local is_win = has 'win32'
  local is_neovide = vim.g.neovide

  if is_mac then
    require 'config.macos'
  end
  if is_win then
    require 'config.windows'
  end
  if is_neovide then
    require 'config.neovide'
  end
end

function parts.update_core(_)
  require 'core.bootstrap'.update 'core'
  RELOAD 'core'
end

function parts.update_keymaps(_)
  require 'core.bootstrap'.update 'keymaps'
  RELOAD 'keymaps'
end

return parts
