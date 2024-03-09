local M = {}

---@type core.config
M.default_config = {
  log_level = vim.log.levels.INFO,
  ui = {
    colorscheme = 'evergarden', -- or 'habamax' or 'zaibatsu' or 'retrobox'
    transparent_background = false,
  },
  modules = {},
}

---@param opts core.config
---@return core.config
function M.setup(opts)
  core.config = vim.tbl_deep_extend('force', M.default_config, opts)
  return core.config
end

return M
