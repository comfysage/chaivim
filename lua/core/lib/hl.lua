---@class core.types.lib.highlight
---@field apply fun(hls: HLGroups )
core.lib.hl = core.lib.hl or {}
core.lib.hl.apply = require 'core.plugin.highlight'.apply

---@class core.types.lib.highlight
---@field get_hl fun(props: { name: string }): core.types.hl.highlight
core.lib.hl.get_hl = function(props)
  return vim.api.nvim_get_hl(0, props)
end

---@class core.types.lib.highlight
---@field get fun(self, ...: string): integer
function core.lib.hl:get(...)
  return vim.tbl_get(self.__value, ...)
end

---@class core.types.lib.highlight
---@field get_theme fun(props: { name: string }): boolean, core.types.lib.hl.table
function core.lib.hl.get_theme(props)
  if not props.name then return false, nil end
  local ok, theme = SR(core.lib.hl.get_theme_module(props.name))
  if not ok then return false, nil end

  return true, core.lib.hl.parse_theme(theme)
end

---@class core.types.lib.hl.theme
---@field type 'dark'|'light'
---@field polish_hl table<string, core.types.hl.highlight>
---@field base_30 table<core.types.lib.hl.theme.base_30.enum, string>
---@field base_16 table<core.types.lib.hl.theme.base_16.enum, string>
---@field ui core.types.lib.hl.theme.ui
---@field syntax core.types.lib.hl.theme.syntax

---@alias core.types.lib.hl.theme.base_30.enum 'white'|'darker_black'|'black'|'black2'|'one_bg'|'one_bg2'|'one_bg3'|'grey'|'grey_fg'|'grey_fg2'|'light_grey'|'red'|'baby_pink'|'pink'|'line'|'green'|'vibrant_green'|'nord_blue'|'blue'|'yellow'|'sun'|'purple'|'dark_purple'|'teal'|'orange'|'cyan'|'statusline_bg'|'lightbg'|'pmenu_bg'|'folder_bg'
---@alias core.types.lib.hl.theme.base_16.enum 'base00'|'base01'|'base02'|'base03'|'base04'|'base05'|'base06'|'base07'|'base08'|'base09'|'base0A'|'base0B'|'base0C'|'base0D'|'base0E'|'base0F'

---@class core.types.lib.hl.theme.ui
---@field accent integer
---@field focus integer
---@field match integer

---@class core.types.lib.hl.theme.syntax
---@field comment integer
---@field special integer
---@field title integer
---@field integer string
---@field identifier integer
---@field field integer
---@field keyword integer
---@field type integer
---@field constant integer
---@field operator integer
---@field structure integer
---@field boolean integer
---@field error integer
---@field warning integer
---@field info integer
---@field hint integer

---@class core.types.lib.highlight
---@field parse_theme fun(theme): core.types.lib.hl.table
function core.lib.hl.parse_theme(theme)
  ---@type table<string, table<string, integer>>
  theme = core.lib.hl.patch_theme(theme)

  ---@type core.types.lib.hl.table
  local _theme = {
    ui = {
      fg = theme.base_30.white,
      bg = theme.base_30.black,
      bg_dark = theme.base_30.darker_black,
      bg_accent = theme.base_30.black2,
      bg1 = theme.base_30.one_bg,
      bg2 = theme.base_30.one_bg2,
      bg3 = theme.base_30.one_bg3,
      current = theme.base_30.grey,
      grey1 = theme.base_30.grey_fg,
      grey2 = theme.base_30.grey_fg2,
      grey3 = theme.base_30.light_grey,
      accent = theme.base_30.green,
      focus = theme.ui.focus,
      match = theme.ui.match,
      border = theme.base_30.line,

      comment = theme.syntax.comment,

      pmenu_bg = theme.base_30.pmenu_bg,
      statusline_bg = theme.base_30.statusline_bg,
      folder_bg = theme.base_30.folder_bg,
      bg_alt = theme.base_30.lightbg,

      red = theme.base_30.red,
      rose = theme.base_30.baby_pink,
      pink = theme.base_30.pink,
      green = theme.base_30.green,
      vibrant = theme.base_30.vibrant_green,
      nord = theme.base_30.nord_blue,
      blue = theme.base_30.blue,
      orange = theme.base_30.orange,
      yellow = theme.base_30.yellow,
      peach = theme.base_30.sun,
      purple = theme.base_30.purple,
      mauve = theme.base_30.dark_purple,
      cyan = theme.base_30.cyan,
      teal = theme.base_30.teal,
    },
    diagnostic = {
      ok = theme.base_30.green,
      error = theme.syntax.error,
      warn = theme.syntax.warning,
      info = theme.syntax.info,
      hint = theme.syntax.hint,
    },
    diff = {
      add = theme.base_30.green,
      change = theme.base_30.teal,
      delete = theme.base_30.red,
    },
    syntax = {
      special = theme.syntax.special,
      title = theme.syntax.title,
      identifier = theme.syntax.identifier,
      type = theme.syntax.type,
      structure = theme.syntax.structure,
      text = theme.syntax.comment,
      method = theme.syntax.constant,
      fn = theme.syntax.constant,
      constructor = theme.syntax.structure,
      field = theme.syntax.field,
      variable = theme.syntax.identifier,
      class = theme.syntax.structure,
      interface = theme.syntax.structure,
      module = theme.syntax.keyword,
      property = theme.syntax.keyword,
      unit = theme.syntax.constant,
      value = theme.syntax.constant,
      enum = theme.syntax.constant,
      keyword = theme.syntax.keyword,
      snippet = theme.syntax.comment,
      color = theme.syntax.constant,
      file = theme.syntax.title,
      reference = theme.syntax.identifier,
      folder = theme.syntax.type,
      enummember = theme.syntax.constant,
      constant = theme.syntax.constant,
      struct = theme.syntax.structure,
      event = theme.syntax.keyword,
      operator = theme.syntax.operator,
      typeparameter = theme.syntax.type,
      namespace = theme.syntax.constant,
      table = theme.syntax.structure,
      object = theme.syntax.structure,
      tag = theme.syntax.identifier,
      array = theme.syntax.type,
      boolean = theme.syntax.boolean,
      number = theme.syntax.constant,
      null = theme.syntax.comment,
      string = theme.syntax.string,
      package = theme.syntax.warning,
    },
  }

  return _theme
end

---@class core.types.lib.highlight
---@field patch_theme fun(theme): core.types.lib.hl.theme
function core.lib.hl.patch_theme(theme)

  theme.syntax = vim.tbl_deep_extend('force', {
    comment = theme.base_30.grey_fg2,
    special = theme.base_30.orange,
    title = theme.base_30.grey_fg2,
    string = theme.base_30.yellow,
    identifier = theme.base_30.white,
    field = theme.base_30.nord_blue,
    keyword = theme.base_30.red,
    type = theme.base_30.yellow,
    constant = theme.base_30.purple,
    operator = theme.base_30.light_grey,
    structure = theme.base_30.red,
    boolean = theme.base_30.purple,
    error = theme.base_30.red,
    warning = theme.base_30.yellow,
    info = theme.base_30.blue,
    hint = theme.base_30.cyan,
  }, theme.syntax or {})

  theme.ui = vim.tbl_deep_extend('force', {
    accent = theme.syntax.string,
    focus = theme.base_30.orange,
    match = theme.base_30.orange,
  }, theme.ui or {})

  for _, t in ipairs({'base_30', 'base_16', 'syntax', 'ui'}) do
    for k, v in pairs(theme[t]) do
      theme[t][k] = core.lib.math.parse_hex_str(v)
    end
  end

  return theme
end

---@class core.types.lib.highlight
---@field get_theme_module fun(name: string): string
function core.lib.hl.get_theme_module(name)
  return ('base46.themes.%s'):format(name)
end

