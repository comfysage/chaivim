require 'core.load.globals'

--- toggle background transparency
---@param props boolean
function _G.toggle_transparent_background(props)
  local is_transparent = false
  if props == nil then
    is_transparent = _G.transparent_background or is_transparent
  else
    is_transparent = not props
  end

  local colors = vim.g.colors_name

  if not _G.transparent_background_fn[colors] then
    return
  end

  if is_transparent then -- set to solid bg
    local fn = _G.transparent_background_fn[colors]
    fn(false)
    _G.transparent_background = false
  else -- set to transparent bg
    local fn = _G.transparent_background_fn[colors]
    fn(true)
    _G.transparent_background = true
  end
  vim.cmd.colorscheme(vim.g.colors_name)
end
