return {
  setup = function(opts)
    require 'core.plugin.hl'.setup()

    if opts.use_overrides then
      require 'core.plugin.highlight'.setup()
    end
  end,
}
