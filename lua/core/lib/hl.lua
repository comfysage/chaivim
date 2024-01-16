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
---@field accent string
---@field focus string
---@field match string

---@class core.types.lib.hl.theme.syntax
---@field comment string
---@field title string
---@field string string
---@field identifier string
---@field field string
---@field keyword string
---@field type string
---@field constant string
---@field operator string
---@field structure string
---@field boolean string
---@field error string
---@field warning string
---@field info string
---@field hint string

---@class core.types.lib.highlight
---@field parse_theme fun(theme): core.types.lib.hl.table
function core.lib.hl.parse_theme(theme)
  theme = core.lib.hl.patch_theme(theme)

  ---@type core.types.lib.hl.table
  local _theme = {
    ui = {
      fg = { fg = theme.base_30.white },
      bg = { bg = theme.base_30.black },
      bg_dark = { bg = theme.base_30.darker_black },
      bg_accent = { bg = theme.base_30.black2 },
      bg1 = { bg = theme.base_30.one_bg },
      bg2 = { bg = theme.base_30.one_bg2 },
      bg3 = { bg = theme.base_30.one_bg3 },
      current = { bg = theme.base_30.grey },
      grey1 = { fg = theme.base_30.grey_fg },
      grey2 = { fg = theme.base_30.grey_fg2 },
      grey3 = { fg = theme.base_30.light_grey },
      accent = { fg = theme.base_30.black, bg = theme.ui.accent },
      focus = { bg = theme.ui.focus },
      match = { fg = theme.ui.match },
      border = { fg = theme.base_30.line },

      comment = { fg = theme.syntax.comment },

      pmenu_bg = { bg = theme.base_30.pmenu_bg },
      statusline_bg = { bg = theme.base_30.statusline_bg },
      folder_bg = { bg = theme.base_30.folder_bg },
      bg_alt = { bg = theme.base_30.lightbg },

      red = { fg = theme.base_30.red },
      rose = { fg = theme.base_30.baby_pink },
      pink = { fg = theme.base_30.pink },
      green = { fg = theme.base_30.green },
      vibrant = { fg = theme.base_30.vibrant_green },
      nord = { fg = theme.base_30.nord_blue },
      blue = { fg = theme.base_30.blue },
      orange = { fg = theme.base_30.orange },
      yellow = { fg = theme.base_30.yellow },
      peach = { fg = theme.base_30.sun },
      purple = { fg = theme.base_30.purple },
      mauve = { fg = theme.base_30.dark_purple },
      cyan = { fg = theme.base_30.cyan },
      teal = { fg = theme.base_30.teal },
    },
    diagnostic = {
      ok = {},
      warn = {},
      error = {},
      info = {},
      hint = {},
    },
    diff = {
      add = { fg = theme.base_30.green },
      change = { fg = theme.base_30.teal },
      delete = { fg = theme.base_30.red },
    },
    syntax = {
      text = { fg = theme.syntax.comment },
      method = { fg = theme.syntax.constant },
      fn = { fg = theme.syntax.constant },
      constructor = { fg = theme.syntax.structure },
      field = { fg = theme.syntax.field },
      variable = { fg = theme.syntax.identifier },
      class = { fg = theme.syntax.structure },
      interface = { fg = theme.syntax.structure },
      module = { fg = theme.syntax.keyword },
      property = { fg = theme.syntax.keyword },
      unit = { fg = theme.syntax.constant },
      value = { fg = theme.syntax.constant },
      enum = { fg = theme.syntax.constant },
      keyword = { fg = theme.syntax.keyword },
      snippet = { fg = theme.syntax.comment },
      color = { fg = theme.syntax.constant },
      file = { fg = theme.syntax.title },
      reference = { fg = theme.syntax.identifier },
      folder = { fg = theme.syntax.type },
      enummember = { fg = theme.syntax.constant },
      constant = { fg = theme.syntax.constant },
      struct = { fg = theme.syntax.structure },
      event = { fg = theme.syntax.keyword },
      operator = { fg = theme.syntax.operator },
      typeparameter = { fg = theme.syntax.type },
      namespace = { fg = theme.syntax.constant },
      table = { fg = theme.syntax.structure },
      object = { fg = theme.syntax.structure },
      tag = { fg = theme.syntax.identifier },
      array = { fg = theme.syntax.type },
      boolean = { fg = theme.syntax.boolean },
      number = { fg = theme.syntax.constant },
      null = { fg = theme.syntax.comment },
      string = { fg = theme.syntax.string },
      package = { fg = theme.syntax.warning },
    },
  }

  return _theme
end

---@class core.types.lib.highlight
---@field patch_theme fun(theme): core.types.lib.hl.theme
function core.lib.hl.patch_theme(theme)

  theme.syntax = vim.tbl_deep_extend('force', {
    comment = theme.base_30.grey_fg,
    title = theme.base_30.grey_fg2,
    string = theme.base_30.vibrant_green,
    identifier = theme.base_30.white,
    field = theme.base_30.blue,
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
    match = theme.base_30.yellow,
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

