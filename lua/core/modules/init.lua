return {
  setup = function(main, module, spec)
    local ok, import = SR(string.format('core.modules.%s.%s', main, module))
    if not ok then
      ok, import = SR_L 'core.modules.default'
      if not ok then
        return
      end
    end

    ---@type ModuleSpec
    ---@diagnostic disable assign-type-mismatch
    local _spec = {
      name = module,
      reload = nil,
      event = nil,
      opts = nil,
      loaded = false,
    }

    -- can be `false` so they needs an explicit nil check
    for _, k in ipairs({ 'reload', 'event', 'opts' }) do
      _spec[k] = (spec[k] == nil and { import.default[k] } or { spec[k] })[1]
    end

    if core.loaded and core.modules[main] and core.modules[main][spec[1]] then
      _spec.loaded = core.modules[main][spec[1]].loaded
    end

    _spec = vim.tbl_deep_extend('force', _spec, import.overwrite)

    return _spec
  end
}
