local Util = require 'core.utils'

return {
  setup = function(opts)
    Util.log 'set up ui'

    if opts.input.enabled then
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require 'core.ui.input' (...)
      end
    end

    if opts.cursor.enabled then
      require 'core.ui.cursor'.setup()
    end
  end,
}
