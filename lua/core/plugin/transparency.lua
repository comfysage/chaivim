local function hl_override(name, props)
  local hl = core.lib.hl.get_hl { name = name }
  return vim.tbl_deep_extend('force', hl, props or {})
end

local function glassify(name)
  return hl_override(name, { bg = 'none' })
end

return {
  setup = function()
    core.lib.autocmd.create {
      event = 'ColorScheme', priority = 100,
      fn = function(_)
        require 'core.plugin.transparency'.fix()
      end,
    }
  end,
  create = function()
    return {
      Normal = { fg = core.lib.hl:get('ui', 'bg').fg, bg = 'none' },
      SignColumn = glassify 'SignColumn',
      LineNr = glassify 'LineNr',
      TabLine = glassify 'TabLine',
      TabLineFill = glassify 'TabLineFill',
    }
  end,
  ---@param mode boolean
  set = function(mode)
    if mode then
      core.lib.hl.apply(require 'core.plugin.transparency'.create())
    else
      require 'core.parts'.colorscheme {}
    end
  end,
  fix = function()
    if core.config.transparent_background ~= nil then
      require 'core.plugin.transparency'.set(core.config.transparent_background)
    end
  end,
  toggle = function()
    if core.config.transparent_background ~= nil then
      core.config.transparent_background = not core.config.transparent_background
      require 'core.plugin.transparency'.fix()
    end
  end,
}
