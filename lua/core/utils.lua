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

---@param props { name: string, url: string }
function Util.git_clone(props)
  local modulepath = core.path[props.name]

  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/" .. props.url .. ".git",
    modulepath,
  })
end

---@param props { name: string, dir: string, mod: string, opts: table|nil }
function Util.boot(props)
  core.path[props.name] = core.path.root .. '/' .. props.dir
  vim.opt.rtp:prepend(core.path[props.name])

  local ok, module = pcall(require, props.mod)
  if ok then
    if props.opts then
      module.setup(props.opts)
    end
  else
    Util.log('module ' .. props.name .. ' not found. bootstrapping...')
    module = require 'core.bootstrap'.load(props.name)
    if props.opts then
      module.setup(props.opts)
    end
  end
end

---@param props { name: string, dir: string, mod: string, url: string, opts: table|nil }
---@return { boot: function, load: function, update: function }|nil
function Util.create_bootstrap(props)
  if not props.name then
    Util.log('error while loading bootstrap spec\n\t`props.name` is empty', 'error')
    return
  end
  if not props.url then
    Util.log('error while loading bootstrap spec\n\t`props.url` is empty', 'error')
    return
  end
  props.dir = props.dir or props.name
  props.mod = props.mod or props.name

  return {
    boot = function()
      Util.boot { name = props.name, dir = props.dir, mod = props.mod, opts = props.opts }
    end,
    load = function()
      Util.git_clone { name = props.name, url = props.url }

      package.loaded[props.name] = nil
      local ok, module = pcall(require, props.mod)
      if not ok then
        return false
      end
      return module
    end,
    update = function()
      Util.git_pull {
        name = props.name,
        path = core.path[props.name],
      }
    end,
  }
end

return Util
