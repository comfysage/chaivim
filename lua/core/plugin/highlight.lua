---@diagnostic disable duplicate-doc-alias

---@alias Color { [1]: string, [2]: integer }
---@alias ColorSpec { [1]: Color, [2]: Color, link: string, reverse: boolean }

---@param group string
---@param colors ColorSpec
local function set_hi(group, colors)
  if vim.tbl_isempty(colors) then
    return
  end

  colors.fg = colors.fg or colors[1] or 'none'
  if type(colors.fg) ~= 'table' then
    colors.fg = { colors.fg, 'none' }
  end
  colors.bg = colors.bg or colors[2] or 'none'
  if type(colors.bg) ~= 'table' then
    colors.bg = { colors.bg, 'none' }
  end

  ---@type vim.api.keyset.highlight
  local color = {}

  for k, v in pairs(colors) do
    color[k] = v
  end

  color.fg = colors.fg[1]
  color.bg = colors.bg[1]
  color.ctermfg = colors.fg[2]
  color.ctermbg = colors.bg[2]
  color[1] = nil
  color[2] = nil
  color.name = nil

  vim.api.nvim_set_hl(0, group, color)
end

---@alias HLGroups { [string]: ColorSpec }

---@param hlgroups HLGroups
local function set_highlights(hlgroups)
  for group, colors in pairs(hlgroups) do
    set_hi(group, colors)
  end
end

return {
  setup = function(opts)
    core.lib.autocmd.create {
      event = 'ColorScheme', priority = 2, -- `2`: after `1` ( `core.hl` is updated )
      fn = function(_)
        require 'core.plugin.highlight'.load()
      end
    }
  end,
  create = function()
    return {
      FloatTitle  = { core.lib.hl:get('ui', 'bg'), core.lib.hl:get('ui', 'accent') },
      FloatBorder = { core.lib.hl:get('ui', 'border')  },
    }
  end,
  apply = function(props)
    set_highlights(props)
  end,
  load = function()
    local ok, module = SR_L 'core.plugin.highlight'
    if not ok then return end
    local hlgroups = module.create()
    module.apply(hlgroups)
  end
}
