local Util = require 'core.utils'

local default_config = {
  config = {},
  module = 'plugins',
}

local lazy_config = {
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
    opts = vim.tbl_deep_extend('force', default_config, opts)
    opts.config = vim.tbl_deep_extend('force', opts.config, lazy_config)

    -- set lazy path
    core.path.lazy = core.path.root .. '/lazy'
    opts.config.root = core.path.lazy

    -- update global
    core.modules.core.lazy.opts = opts

    Util.log 'loading lazy.'
    require 'core.bootstrap'.boot 'lazy'

    Util.log 'loading plugins.'
    require 'lazy'.setup(opts.module, opts.config)
  end
}
