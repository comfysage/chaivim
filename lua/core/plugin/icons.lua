---@alias Icons { [string]: string }

---@class CoreIcons
---@field syntax Icons
---@field item Icons
---@field info Icons
---@field diagnostic Icons
---@field separator Icons

return {
  ---@return CoreIcons
  create = function()
    return {
      syntax = {
        text          = '',
        method        = '',
        fn            = '',
        constructor   = '',
        field         = 'ﰠ',
        variable      = '󰀫',
        class         = 'ﴯ',
        interface     = '',
        module        = '',
        property      = 'ﰠ',
        unit          = '',
        value         = '',
        enum          = '',
        keyword       = '',
        snippet       = '',
        color         = '',
        file          = '',
        reference     = '',
        folder        = '',
        enummember    = '',
        constant      = '',
        struct        = 'פּ',
        event         = '',
        operator      = '',
        typeparameter = '',
        namespace     = '󰌗',
        table         = '',
        object        = '󰅩',
        tag           = '',
        array         = '[]',
        boolean       = '',
        number        = '',
        null          = '󰟢',
        string        = '\'\'',
        package       = '',
      },
      item = {
        colors = '󰏘',
        find = '',
      },
      info = {
        loaded = "●",
        not_loaded = "○",
      },
      diagnostic = {
        error = '󰅙',
        warn = '',
        info = '󰋼',
        hint = '󰌵',
      },
      separator = {
        slant = { left = "", right = "" },
        round = { left = "", right = "" },
        block = { left = "█", right = "█" },
        arrow = { left = "", right = "" },
      },
    }
  end,
  setup = function()
    core.lib.icons = require 'core.plugin.icons'.create()

    -- [FIXME]
    ---@deprecated
    core.icons = require 'core.plugin.icons'.create()
  end,
}
