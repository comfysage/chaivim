---@diagnostic disable duplicate-doc-alias

---@alias core.types.hl.color string|integer|'none'

---@alias core.types.hl.highlight { name: string, fg: core.types.hl.color, bg: core.types.hl.color  }

---@class core.types.lib.hl.table
---@field ui core.types.hl.table.ui
---@field diagnostic table<core.types.lib.hl.table.diagnostic.enum, core.types.hl.highlight>
---@field diff table<core.types.lib.hl.table.diff.enum, core.types.hl.highlight>
---@field syntax table<core.types.lib.hl.table.syntax.enum, core.types.hl.highlight>

---@class core.types.lib.hl.table.ui
---@field bg core.types.hl.highlight normal bg
---@field bg_accent core.types.hl.highlight bg for items that require visual priority; signcolumn
---@field accent core.types.hl.highlight accent color for titles and tabs
---@field current core.types.hl.highlight bg color for current item
---@field focus core.types.hl.highlight focused item
---@field match core.types.hl.highlight color for matching text
---@field border core.types.hl.highlight fg color for borders and window separators
---@alias core.types.lib.hl.table.diagnostic.enum 'ok'|'warn'|'error'|'info'|'hint'
---@alias core.types.lib.hl.table.diff.enum 'add'|'change'|'delete'
---@alias core.types.lib.hl.table.syntax.enum 'text'|'method'|'fn'|'constructor'|'field'|'variable'|'class'|'interface'|'module'|'property'|'unit'|'value'|'enum'|'keyword'|'snippet'|'color'|'file'|'reference'|'folder'|'enummember'|'constant'|'struct'|'event'|'operator'|'typeparameter'|'namespace'|'table'|'object'|'tag'|'array'|'boolean'|'number'|'null'|'string'|'package'

---@alias CoreHlName core.types.lib.hl.table.ui.enum|core.types.lib.hl.table.diagnostic.enum|core.types.lib.hl.table.diff.enum|core.types.lib.hl.table.syntax.enum

---@param props { [1]: CoreHlName, [2]: core.types.hl.color|nil, [3]: core.types.hl.color|nil , fg: core.types.hl.color|nil, bg: core.types.hl.color|nil, from: core.types.hl.color|nil, inverse: boolean|nil }[]
---@return { [string]: core.types.hl.highlight }
local function create_hls(props)
  local hls = {}
  for _, v in ipairs(props) do
    local name = v[1]
    local fg = v.fg or v[2]
    local bg = v.bg or v[3]

    -- if from is defined, then empty fields will be filled in
    if v.from then
      local copy = vim.api.nvim_get_hl(0, { name = v.from })
      fg = fg or copy.fg
      bg = bg or copy.bg
    end
    hls[name] = { name = name, fg = fg or 'none', bg = bg or 'none' }

    local fg = hls[name].fg
    local bg = hls[name].bg
    if type(fg) == 'number' and type(bg) == 'number' and bg > fg then
      hls[name].fg = bg
      hls[name].bg = fg
      if v.inverse then
        hls[name].fg = fg
        hls[name].bg = bg
      end
    elseif bg == 'none' and v.inverse then
      hls[name].fg = 0
      hls[name].bg = fg
    end
  end
  return hls
end

return {
  setup = function()
    require 'core.plugin.hl'.load()

    require 'core.load.handle'.create {
      event = 'ColorScheme', priority = 1,
      fn = function(_)
        require 'core.plugin.hl'.load()
      end,
    }
  end,
  ---@return core.types.lib.hl.table
  create = function()
    return {
      ui = create_hls {
        { 'bg',        from = 'Normal' },
        { 'fg',        from = 'Normal', bg = 'none' },
        { 'bg_accent', from = 'SignColumn' },
        { 'accent',    from = 'TablineSel', inverse = true },
        { 'current',   from = 'CursorLine' },
        { 'focus',     from = 'IncSearch' },
        { 'match',     from = 'Search' },
        { 'border',    from = 'WinSeparator' },
        { 'comment',   from = 'Comment' },
      },
      diagnostic = create_hls {
        { 'ok',    from = 'DiagnosticOk' },
        { 'warn',  from = 'DiagnosticWarn' },
        { 'error', from = 'DiagnosticError' },
        { 'info',  from = 'DiagnosticInfo' },
        { 'hint',  from = 'DiagnosticHint' },
      },
      diff = create_hls {
        { 'add',    from = 'DiffAdd' },
        { 'change', from = 'DiffChange' },
        { 'delete', from = 'DiffAdd' },
      },
      syntax = create_hls {
        { 'text', from = 'Comment' },
        { 'method', from = 'Constant' },
        { 'fn', from = 'Constant' },
        { 'constructor', from = 'Structure' },
        { 'field', from = 'Identifier' },
        { 'variable', from = 'Identifier' },
        { 'class', from = 'Structure' },
        { 'interface', from = 'Structure' },
        { 'module', from = 'Keyword' },
        { 'property', from = 'Keyword' },
        { 'unit', from = 'Constant' },
        { 'value', from = 'Constant' },
        { 'enum', from = 'Constant' },
        { 'keyword', from = 'Keyword' },
        { 'snippet', from = 'Comment' },
        { 'color', from = 'Constant' },
        { 'file', from = 'Title' },
        { 'reference', from = 'Identifier' },
        { 'folder', from = 'Type' },
        { 'enummember', from = 'Constant' },
        { 'constant', from = 'Constant' },
        { 'struct', from = 'Structure' },
        { 'event', from = 'Keyword' },
        { 'operator', from = 'Operator' },
        { 'typeparameter', from = 'Type' },
        { 'namespace', from = 'Constant' },
        { 'table', from = 'Structure' },
        { 'object', from = 'Structure' },
        { 'tag', from = 'Identifier' },
        { 'array', from = 'Type' },
        { 'boolean', from = 'Boolean' },
        { 'number', from = 'Constant' },
        { 'null', from = 'Comment' },
        { 'string', from = 'Comment' },
        { 'package', from = 'healthWarning' },
      },
    }
  end,
  load = function()
    core.lib.hl = core.lib.hl or {}
    core.lib.hl.__value = require 'core.plugin.hl'.create()

    -- [FIXME]
    ---@deprecated
    core.hl = require 'core.plugin.hl'.create()
  end
}
