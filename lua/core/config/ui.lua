local Util = require 'core.utils'

return {
  setup = function(opts)
    Util.log 'set up ui'

    if opts.input.enabled then
      vim.ui.input = function(...)
        require 'core.ui.input' (...)
      end
    end
  end,
}
