local Util = {}

--- vim.notify wrapper to avoid msg overload
---@param msg string
---@param level 'debug'|'info'|'warn'|'error'|nil
function Util.log(msg, level)
  core.log:write('core.core', msg, level)
end

---@param name string
function Util.has(name)
  local value = vim.fn.has(name)
  return value == 1
end

---@param plugins table<string>
function Util.load_plugins(plugins)
  for _, url in ipairs(plugins) do
    local _url = vim.split(url, '/')
    if #_url > 1 then
      Util.add_to_path(_url[#_url])
    end
  end
end

---@param path string
function Util.add_to_path(path)
  vim.opt.rtp:prepend(path)
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

  local obj = vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/" .. props.url .. ".git",
    modulepath,
  }, { cwd = core.path.root }):wait()
  if obj.code > 0 then
    Util.log('error while cloning ' .. props.name .. ' at ' .. modulepath ..
      '\n\t' .. obj.stdout .. '\n\t' .. obj.stderr, 'error')
    return
  end
  Util.log('succesfully cloned ' .. props.name, 'info')
end

---@param props { name: string, dir: string, mod: string, opts: table|nil|boolean }
function Util.boot(props)
  local dir = core.path.root .. '/' .. props.dir
  core.path[props.name] = dir

  if not vim.loop.fs_stat(dir) then
    Util.log('module ' .. props.name .. ' not found. bootstrapping...', 'warn')
    require 'core.bootstrap'.load(props.name)
  end
  Util.add_to_path(dir)

  if props.opts == false then
    return
  end

  local ok, result = SR(props.mod)

  if ok then
    if props.opts then
      result.setup(props.opts)
    end
    return
  end

  Util.log('error while bootstrapping ' .. props.name .. '\n\t' .. (result or ''), 'error')
end

---@param props { name: string, dir: string, mod: string, url: string, opts: table|nil|boolean }
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
    end,
    update = function()
      Util.git_pull {
        name = props.name,
        path = core.path[props.name],
      }
    end,
  }
end

function Util.get_diagnostic_signs()
  return {
    [vim.diagnostic.severity.ERROR] = core.lib.icons.diagnostic.error,
    [vim.diagnostic.severity.WARN] = core.lib.icons.diagnostic.warn,
    [vim.diagnostic.severity.INFO] = core.lib.icons.diagnostic.info,
    [vim.diagnostic.severity.HINT] = core.lib.icons.diagnostic.hint,
  }
end

return Util
