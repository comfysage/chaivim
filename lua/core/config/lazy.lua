local Util = require 'core.utils'

local lazy_config = {
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 90, height = 0.8 },
    wrap = true, -- wrap the lines in the ui
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = 'none',
  },
}

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
    opts = opts or {}
    opts.config = vim.tbl_deep_extend('force', lazy_config, opts.config)
    opts.config = vim.tbl_deep_extend('force', opts.config, overwrite)

    -- set lazy path
    opts.config.root = core.path.root

    -- update global
    core.modules.core.lazy.opts = opts

    Util.log 'loading lazy.'
    require 'core.bootstrap'.boot 'lazy'

    Util.log 'loading plugins.'
    require 'lazy'.setup('core.lazy.plugins', opts.config)
  end
}
