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

---@param props { [1]: CoreHlName, [2]: Color|nil, [3]: Color|nil , fg: Color|nil, bg: Color|nil, from: Color|nil, inverse: boolean|nil }[]
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

    if v.inverse then
      local fg = hls[name].fg
      local bg = hls[name].bg
      if type(fg) == 'number' and type(bg) == 'number' and fg > bg then
        hls[name].fg = bg
        hls[name].bg = fg
      elseif bg == 'none' then
        hls[name].fg = 0
        hls[name].bg = fg
      end
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
  ---@return CoreHighlights
  create = function()
    return {
      ui = create_hls {
        { 'bg',        from = 'Normal' },
        { 'bg_accent', from = 'SignColumn' },
        { 'accent',    from = 'TablineSel', inverse = true },
        { 'current',   from = 'CursorLine' },
      },
      diagnostic = create_hls {
        { 'ok',    from = 'DiagnosticOk' },
        { 'warn',  from = 'DiagnosticWarn' },
        { 'error', from = 'DiagnosticError' },
        { 'info',  from = 'DiagnosticInfo' },
        { 'hint',  from = 'DiagnosticHint' },
      },
    }
  end,
  load = function()
    core.hl = require 'core.plugin.hl'.create()
  end
}
