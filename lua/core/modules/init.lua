local Util = require 'core.utils'

local default_modules = {
  core = {
    'base', 'options', 'ui', 'highlights', 'keymaps',
    'lazy', 'lualine', 'treesitter', 'lsp', 'cmp',
    'telescope', 'mini',
    'dash',
  },
}

return {
  get_module = function(main, module)
    return SR(string.format('core.modules.%s.%s', main, module))
  end,
  get_defaults = function(main)
    if not default_modules[main] then
      return {}
    end

    local modules = {}
    for i, module in ipairs(default_modules[main]) do
      modules[module] = require 'core.modules'.setup(main, module, {
        priority = i,
      })
    end
    return modules
  end,
  setup = function(main, module, spec)
    local ok, default = SR_L 'core.modules.default'
    if not ok then
      return
    end
    ---@diagnostic disable-next-line redefined-local
    local ok, import = require 'core.modules'.get_module(main, module)
    if not ok then
      import = {}
    end
    import = vim.tbl_deep_extend('force', default, import)

    ---@type ModuleSpec
    local _spec = {
      name = module,
      reload = nil,
      event = nil,
      opts = nil,
      loaded = false,
    }

    _spec = vim.tbl_deep_extend('force', _spec, spec)
    _spec = vim.tbl_deep_extend('force', import.default, _spec)

    if core.loaded and core.modules[main] and core.modules[main][module] then
      _spec.loaded = core.modules[main][module].loaded
    end

    _spec = vim.tbl_deep_extend('force', _spec, import.overwrite)

    return _spec
  end
}
