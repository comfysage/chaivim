local Util = require 'core.utils'

_G.Keymap = _G.Keymap or {}

_G.Keymap.group = _G.Keymap.group or function(props)
  if not props.group then
    Util.log('`Keymap.group` requires `group` field', 'warn')
    return
  end
  local mappings = props[1] or {}
  if #props > 1 then
    mappings = props
  end
  for _, map in ipairs(mappings) do
    if #map < 4 then
      Util.log('`Keymap.group` requires 4 paramaters per keymap', 'warn')
      goto continue
    end
    local mode = map[1]
    local lhs = map[2]
    local rhs = map[3]
    local desc = map[4]
    keymaps[mode][lhs] = { rhs, desc, group = props.group }
    ::continue::
  end
end

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
      Keymap.group { group = group, mappings }
    end
  end
}
