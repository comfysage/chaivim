local Util = require 'core.utils'

local function load_plugin(name, spec)
  Util.log(string.format('loading mini.%s', name))
  local mod = require('mini.' .. name)
  spec.config = spec.config or function(_, opts) mod.setup(opts) end
  spec.config(mod, spec.opts)
end

return {
  setup = function(opts)
    Util.log 'loading mini.'
    require 'core.bootstrap'.boot 'mini'

    for name, c in pairs(opts.plugins) do
      load_plugin(name, c)
    end
  end
}
