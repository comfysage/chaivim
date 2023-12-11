return {
  setup = function(main, module, spec)
    local ok, default = SR_L 'core.modules.default'
    if not ok then
      return
    end
    ---@diagnostic disable-next-line redefined-local
    local ok, import = SR(string.format('core.modules.%s.%s', main, module))
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

    _spec = vim.tbl_deep_extend('force', _spec, import.default)

    if core.loaded and core.modules[main] and core.modules[main][module] then
      _spec.loaded = core.modules[main][module].loaded
    end

    _spec = vim.tbl_deep_extend('force', _spec, import.overwrite)

    return _spec
  end
}
