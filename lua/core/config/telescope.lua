local Util = require 'core.utils'

local M = {}

local themes = {
  minimal = {
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    },
    highlights = {
      TelescopeTitle = { core.hl.ui.accent, { reverse = true } },
      TelescopeNormal = { core.hl.ui.bg },
      TelescopePromptNormal = { core.hl.ui.bg_accent },
      TelescopeSelection = { core.hl.ui.current },
    },
  },
  main = {
    borderchars = {
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      prompt = { " ", "│", "─", "│", '│', '│', "╯", "╰" },
      results = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    },
    highlights = {
      TelescopeTitle = { core.hl.ui.accent, { reverse = true } },
      TelescopeNormal = { core.hl.ui.bg },
      TelescopePromptNormal = { core.hl.ui.bg_accent },
      TelescopeSelection = { core.hl.ui.current },
    },
  },
}

local function use_theme(theme_name)
  if not theme_name then
    return
  end
  vim.api.nvim_set_hl(0, 'Telescope', {})

  local theme = themes[theme_name]
  if not theme then
    Util.log('theme with name `' .. theme_name .. '` not found', 'error')
    return
  end

  require 'telescope'.setup {
    defaults = {
      borderchars = theme.borderchars,
    },
  }

  for hl_name, hl_v in pairs(theme.highlights) do
    local hl_group = hl_v[1]
    if hl_v[2] then
      hl_group = vim.tbl_extend('force', hl_group, hl_v[2])
    end
    hl_group.name = nil

    vim.api.nvim_set_hl(0, hl_name, hl_group)
  end
end

---@class CoreTelescopeOpts
---@field config TelescopeConfig
---@field use_fzf boolean
---@field theme 'main'|'minimal'

---@param opts CoreTelescopeOpts
M.setup = function(opts)
  require 'telescope'.setup(opts.config)

  if opts.use_fzf then
    require 'telescope'.load_extension 'fzf'
  end

  if opts.theme and type(opts.theme) == 'string' then
    require 'core.load.handle'.create {
      event = 'ColorScheme', priority = 5,
      fn = function(_)
        use_theme(core.modules.core.telescope.opts.theme)
      end
    }
  end
end

return M
