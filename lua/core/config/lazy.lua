local Util = require 'core.utils'

local overwrite = {
  root = nil, -- directory where plugins will be installed
  -- required for core bootstrap
  performance = {
    reset_packpath = false,
    rtp = {
      reset = false,
    },
  },
}

return {
  setup = function(opts)
    opts.config = vim.tbl_deep_extend('force', opts.config, overwrite)

    -- set lazy path
    opts.config.root = core.path.lazy

    -- update global
    core.modules.core.lazy.opts = opts

    Util.log('lazy.setup', 'loading lazy.')
    require 'core.bootstrap'.boot 'lazyplug'

    Util.log('lazy.setup', 'loading plugins.')
    ---@diagnostic disable-next-line: redundant-parameter
    require 'lazy'.setup('core.lazy.plugins', opts.config)
  end,
}
