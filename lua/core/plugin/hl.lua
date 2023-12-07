---@alias Color string|'none'

---@alias Highlight { name: string, fg: Color, bg: Color  }

---@class CoreHighlights
---@field ui CoreUIHighlights
---@field diagnostic CoreDiagnosticHighlights

---@alias CoreUIHighlights { [CoreUIHlName]: Highlight }
---@alias CoreUIHlName 'bg'|'bg_accent'|'accent'|'current'

---@alias CoreDiagnosticHighlights { [CoreDiagnosticHlName]: Highlight }
---@alias CoreDiagnosticHlName 'ok'|'warn'|'error'|'info'|'hint'

---@alias CoreHlName CoreUIHlName|CoreDiagnosticHlName

---@param props { [1]: CoreHlName, [2]: Color|nil, [3]: Color|nil , fg: Color|nil, bg: Color|nil, from: Color|nil }[]
---@return { [string]: Highlight }
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
  end
  return hls
end

return {
  setup = function()
    require 'core.load.handle'.create {
      event = 'ColorScheme', priority = 1,
      fn = function(_)
        require 'core.plugin.hl'.load()
      end,
    }
  end,
  ---@return CoreHighlights
  create = function()
    return {
      ui = create_hls {
        { 'bg',        from = 'Normal',     fg = 'none' },
        { 'bg_accent', from = 'SignColumn', fg = 'none' },
        { 'accent',    from = 'TablineSel', bg = 'none' },
        { 'current',   from = 'CursorLine', fg = 'none' },
      },
      diagnostic = create_hls {
        { 'ok',    from = 'DiagnosticOk',    bg = 'none' },
        { 'warn',  from = 'DiagnosticWarn',  bg = 'none' },
        { 'error', from = 'DiagnosticError', bg = 'none' },
        { 'info',  from = 'DiagnosticInfo',  bg = 'none' },
        { 'hint',  from = 'DiagnosticHint',  bg = 'none' },
      },
    }
  end,
  load = function()
    core.hl = require 'core.plugin.hl'.create()
  end
}
