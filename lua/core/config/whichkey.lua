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

    if not opts.config.key_labels then
      opts.config.key_labels =
        core.lib.options:get('ui', 'general', 'key_labels')
    end
    which.setup(opts.config)

    which.register {
      ['.'] = { name = 'toggle' },
      [','] = { name = 'edit' },
      ['<leader>'] = {
        f = { name = 'find' },
        s = { name = 'show' },
        g = { name = 'go' },
      },
    }
  end,
}
