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

    for group, mappings in pairs(opts.mappings) do
      for _, map in ipairs(mappings) do
        if #map < 4 then
          goto continue
        end
        local mode = map[1]
        local lhs = map[2]
        local rhs = map[3]
        local desc = map[4]
        keymaps[mode][lhs] = { rhs, desc, group = group }
        ::continue::
      end
    end
  end
}
