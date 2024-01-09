local Util = require 'core.utils'

return {
  setup = function(opts)
    local _leader = opts.leader
    if opts.leader == 'space' or opts.leader == 'SPC' then
      _leader = ' '
    end

    local _localleader = opts.localleader
    if not _localleader then
      _localleader = _leader .. ','
    end

    Util.log('keymaps.setup', string.format('set leader to "%s"', _leader))
    Util.log('keymaps.setup', string.format('set localleader to "%s"', _localleader))
    vim.g.mapleader = _leader
    vim.g.maplocalleader = _localleader

    require 'keymaps'.setup {
      default_opts = opts.defaults,
      special_keys = opts.special_keys
    }
    keymaps_config.repl_keys = {}
    for m, k in pairs(keymaps_config.special_keys) do
      keymaps_config.repl_keys[string.lower(k)] = m
    end
    keymaps_config.repl_keys['<leader>'] = opts.leader
    keymaps_config.repl_keys['<[c]%-([%w])>'] = 'CTRL+%1'
    keymaps_config.repl_keys['<[m]%-([%w])>'] = 'META+%1'
    keymaps_config.repl_keys['<[a]%-([%w])>'] = 'ALT+%1'

    -- load keymaps plugin
    for group, mappings in pairs(opts.mappings) do
      Keymap.group { group = group, mappings }
    end
  end,
  cheatsheet = function(props)
    require 'core.ui.cheatsheet'.open(props)
  end,
}
