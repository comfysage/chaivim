local Util = require 'core.utils'

return {
  setup = function(opts)
    P(opts)
    Util.log('whichkey.setup', 'loading whichkey.')
    require('core.bootstrap').boot 'whichkey'

    local ok, which = SR_L 'which-key'
    if not ok then
      return
    end

    which.setup(opts.config)
  end,
}
