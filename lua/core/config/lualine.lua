local Util = require 'core.utils'

---@alias fmt_f fun(str: string): string
---@alias wrapper_f fun(): string
---@alias separator { left: string, right: string }
---
---@class LualineConfig__component
---@field [1] string
---@field fmt fmt_f|nil
---@field icon string|nil
---@field separator separator|nil
---@field cond function|nil
---@field draw_empty boolean|nil
---@field color any|nil
---@field type any|nil
---@field padding integer|nil
---@field on_click function|nil

---@class LualineConfig__options
---@field icons_enabled boolean
---@field theme 'auto'|string
---@field component_separators separator
---@field section_separators separator
---@field always_divide_middle boolean
---@field globalstatus boolean
---@field refresh { ['statusline'|'tabline'|'winbar']: integer }
---@class LualineConfig__sections
---@field lualine_a LualineConfig__section
---@field lualine_b LualineConfig__section
---@field lualine_c LualineConfig__section
---@field lualine_x LualineConfig__section
---@field lualine_y LualineConfig__section
---@field lualine_z LualineConfig__section
---@alias LualineConfig__section (LualineConfig__component|wrapper_f|string)[]

---@class LualineConfig
---@field options LualineConfig__options
---@field sections LualineConfig__sections
---@field inactive_sections LualineConfig__sections

---@alias LualineStyle 'minimal'

---@type { [LualineStyle]: LualineConfig }
local styles = {
  minimal = {
    options = {
      component_separators = '', -- { left = '', right = '' },
      section_separators = '',   -- { left = '', right = '' },
    }
  }
}

---@class CoreLualineOpts
---@field config LualineConfig
---@field style LualineStyle

return {
  ---@param opts CoreLualineOpts
  setup = function(opts)
    Util.log 'loading lualine.'
    require 'core.bootstrap'.boot 'lualine'

    local ok, lualine = SR_L 'lualine'
    if not ok then
      return
    end

    local config = opts.config
    if opts.style and styles[opts.style] then
      config = vim.tbl_deep_extend('force', config, styles[opts.style])
    end

    lualine.setup(config)
  end
}
