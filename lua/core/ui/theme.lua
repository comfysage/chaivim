local Util = require 'core.utils'

return {
  create = function(theme)
    return {
      Normal = { theme.ui.fg, theme.ui.bg },
      NormalFloat = { theme.ui.fg, theme.ui.bg },
      TabLine  = theme.ui.accent,
      TabLineFill  = { link = "TabLine" },
      TabLineSel  = theme.ui.accent,
      FloatTitle  = theme.ui.accent,
      WinSeparator = theme.ui.border,
      VertSplit = { link = 'WinSeparator' },
      FloatBorder = theme.ui.border,
    }
  end,
  apply = function()
    Util.log('core.ui', 'applying theme')
    local theme = core.lib.hl.__value
    local hl_groups = require 'core.ui.theme'.create(theme)
    core.lib.hl.apply(hl_groups)
  end,
  load = function()
    local colorscheme = core.lib.options:get('ui', 'general', 'colorscheme')
    if colorscheme == nil then return end
    require 'core.bootstrap'.boot 'base46'
    local ok, theme = core.lib.hl.get_theme { name = colorscheme }
    if not ok then
      require 'core.utils'.log('core.hl', ('could\'t load theme "%s"'):format(colorscheme))
      return
    end

    core.lib.hl = core.lib.hl or {}
    core.lib.hl.__value = theme

    -- [FIXME]
    ---@deprecated
    core.hl = core.lib.hl.__value

    require 'core.ui.theme'.apply()
  end,
}
