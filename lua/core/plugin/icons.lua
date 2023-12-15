---@alias Icons { [string]: string }

---@class CoreIcons
---@field syntax Icons
---@field item Icons
---@field info Icons
---@field diagnostic Icons

---@type CoreIcons
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
    error = 'E',
    warn = 'W',
    info = 'I',
    hint = 'H',
  },
}
