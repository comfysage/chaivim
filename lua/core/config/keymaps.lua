local Util = require 'core.utils'

return {
  setup = function(opts)
    Util.log(string.format('setting leader to "%s"', vim.g.mapleader))

    if opts.leader == 'space' or opts.leader == 'SPC' then
      opts.leader = ' '
    end

    vim.g.mapleader = opts.leader
    vim.g.maplocalleader = opts.leader

    require 'keymaps'.setup {
      default_opts = opts.defaults,
    }
  end
}
