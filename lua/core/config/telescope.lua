local M = {}

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
      fuzzy = true,                         -- false will only do exact matching
      override_generic_sorter = true,       -- override the generic sorter
      override_file_sorter = true,          -- override the file sorter
      case_mode = 'smart_case',             -- or 'ignore_case' or 'respect_case', defaults to 'smart_case'
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

---@param opts CoreTelescopeOpts
M.setup = function(opts)
  local config = vim.tbl_deep_extend('force', default_config, opts.config or {})

  require 'telescope'.setup (config)

  if opts.use_fzf then
    require 'telescope'.load_extension 'fzf'
  end
end

return M
