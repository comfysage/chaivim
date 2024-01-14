local Util = require 'core.utils'

local lazy_config = {
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 90, height = 0.8 },
    wrap = true, -- wrap the lines in the ui
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = 'none',
    icons = {
      cmd = "! ",
      config = core.lib.icons.syntax.constructor,
      event = core.lib.icons.syntax.event,
      ft = core.lib.icons.syntax.file,
      init = core.lib.icons.syntax.constructor,
      import = core.lib.icons.syntax.reference,
      keys = core.lib.icons.syntax.snippet,
      lazy = core.lib.icons.syntax.fn,
      loaded = core.icons.info.loaded,
      not_loaded = core.icons.info.not_loaded,
      plugin = core.icons.syntax.package,
      runtime = core.icons.syntax.null,
      source = core.icons.syntax.module,
      start = core.icons.debug.start,
      task = core.icons.ui.item_prefix,
      list = {
        '-',
        '*',
        '*',
        '-',
      },
    },
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
    opts.config.root = core.path.lazy

    -- update global
    core.modules.core.lazy.opts = opts

    Util.log('lazy.setup', 'loading lazy.')
    require 'core.bootstrap'.boot 'lazyplug'

    Util.log('lazy.setup', 'loading plugins.')
    ---@diagnostic disable-next-line: redundant-parameter
    require 'lazy'.setup('core.lazy.plugins', opts.config)
  end
}
