return {
  setup = function(opts)
    for name, props in pairs(opts.commands) do
      require 'core.plugin.command'.create {
        name = name,
        fn = type(props) == 'table' and props.fn or props,
        opts = type(props) == 'table' and props.opts or nil,
      }
    end
  end,
}
