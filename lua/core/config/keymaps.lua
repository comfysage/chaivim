local Util = require 'core.utils'

return {
  setup = function(opts)
    local _leader = opts.leader
    if opts.leader == 'space' or opts.leader == 'SPC' then
      _leader = ' '
    end

    local _localleader = _leader .. opts.localleader

    Util.log('keymaps.setup', string.format('set leader to "%s"', _leader))
    Util.log('keymaps.setup', string.format('set localleader to "%s"', _localleader))
    vim.g.mapleader = _leader
    vim.g.maplocalleader = _localleader

    -- key labels
    local key_labels = core.config.ui.key_labels
    local repl_keys = {}

    if not opts.special_keys then
      opts.special_keys = {}
      for m, k in pairs(key_labels) do
        opts.special_keys[k] = m
        repl_keys[string.lower(m)] = k
      end
    else
      for m, k in pairs(opts.special_keys) do
        repl_keys[string.lower(k)] = m
      end
    end
    require 'keymaps'.setup {
      default_opts = opts.defaults,
      special_keys = opts.special_keys
    }
    keymaps_config.repl_keys = repl_keys
    keymaps_config.repl_keys['<leader>'] = opts.leader
    keymaps_config.repl_keys['<localleader>'] = opts.leader .. '+' .. opts.localleader
    keymaps_config.repl_keys['<[c]%-([%w])>'] = 'CTRL+%1'
    keymaps_config.repl_keys['<[m]%-([%w])>'] = 'META+%1'
    keymaps_config.repl_keys['<[a]%-([%w])>'] = 'ALT+%1'
    keymaps_config.repl_keys['<[s]%-([%w])>'] = 'SHIFT+%1'

    -- load keymaps plugin
    for group, mappings in pairs(opts.mappings) do
      Keymap.group { group = group, mappings }
    end
  end,
  cheatsheet = function(props)
    require 'core.ui.cheatsheet'.open(props)
  end,
}
