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

---@param props { name: string|nil, path: string|nil }
function Util.git_pull(props)
  if not props.path then
    Util.log 'no path specified in `git_pull()`'
    return
  end

  local name = props.name or vim.fs.basename(props.path)

  local obj = vim.system({
    "git",
    "pull",
  }, { cwd = props.path }):wait()
  if obj.code > 0 then
    Util.log('error while updating ' .. name .. ' at ' .. props.path ..
      '\n\t' .. obj.stdout .. '\n\t' .. obj.stderr, 'error')
    return
  end
  Util.log('succesfully updated ' .. name, 'info')
end

---@param props { name: string, dir: string, mod: string, opts: table|nil }
function Util.boot(props)
  core.path[props.name] = core.path.root .. '/' .. props.dir
  vim.opt.rtp:prepend(core.path[props.name])

  local ok, module = pcall(require, props.mod)
  if ok then
    if props.opts then
      module.setup (props.opts)
    end
  else
    Util.log('module ' .. props.name .. ' not found. bootstrapping...')
    module = require 'core.bootstrap'.load(props.name)
    if not module then
      Util.log('error while bootstrapping.', 'error')
      return
    end
    if props.opts then
      module.setup (props.opts)
    end
  end
end

return Util
