local Util = {}

--- vim.notify wrapper to avoid msg overload
---@param msg string
---@param level 'debug'|'info'|'warn'|'error'|nil
function Util.log(msg, level)
  level = level or 'debug'
  local log_levels = {
    debug = vim.log.levels.DEBUG,
    info  = vim.log.levels.INFO,
    warn  = vim.log.levels.WARN,
    error = vim.log.levels.ERROR,
  }
  local log_level = log_levels[level] or log_levels['debug']

  if log_level < core.config.log_level then
    return
  end

  vim.notify(msg, log_level)
end

return Util
