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

---@alias TelescopeConfig {}

---@type TelescopeConfig
local default_config = {
  defaults = {
    prompt_prefix = '$ ',
    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
    path_display = nil,
    file_ignore_patterns = { 'node_modules', '%.git/' },
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { "─", "│", "─", "│", '┌', '┐', "┘", "└" },
      results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = 'smart_case',       -- or 'ignore_case' or 'respect_case', defaults to 'smart_case'
    },
  },
  pickers = {
    find_files = {
      disable_devicons = false,
    },
  },
}

---@class CoreTelescopeOpts
---@field config TelescopeConfig
---@field use_fzf boolean
---@field theme 'main'|'minimal'

---@param opts CoreTelescopeOpts
M.setup = function(opts)
  local config = vim.tbl_deep_extend('force', default_config, opts.config or {})

  require 'telescope'.setup(config)

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
