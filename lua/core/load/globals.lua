CONFIG_MODULE = "config"

CR = CR or "~/.config"

ENV = function(v)
    if not vim.fn.has_key(vim.fn.environ(), v) then
        return ""
    end
    return vim.fn.environ()[v]
end

CR_PATH = function (v)
    return CR .. "/" .. v
end

P = function (v)
 print(vim.inspect(v))
 return v
end

RELOAD = function (...)
 return require("plenary.reload").reload_module(...)
end

R = function (name)
 RELOAD(name)
 return require(name)
end

V = function ()
 vim.ui.input({ prompt = '' }, function (name)
  local sp = vim.split(name, ".", { plain = true, trimempty = true })

  local basepath = CR_PATH 'nvim'
  local p = ''

  for i, n in pairs(sp) do
    p = p .. "/"
   if i == #sp then
    p = p .. n .. '.lua'
   else
    p = p .. n
   end
  end

  local path = basepath .. p
  vim.notify(path)
 end)
end

MT = function (t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                MergeTable(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

CUTIL = {}

CUTIL.PATH_DIR = function (_)
  local _dir = vim.fn.expand('%:.:h')
  local name
  if _dir == '.' then
    name = ''
  else
    name = _dir
  end
  return name
end

-- if in visual mode, returns number of visually selected words
CUTIL.WORD_COUNT = function (_)
  local w_count = vim.fn.wordcount()
  local count = 0
  if w_count['visual_words'] then
    count = w_count['visual_words']
  else
    count = w_count['words']
  end
  if count == 0 then
    return ""
  end
  return count
end

-- if in visual mode, returns number of visually selected lines
CUTIL.LINE_COUNT = function (_)
  local _vstart = vim.fn.line('v')
  local _vend = vim.fn.line('.')

  local diff = _vend - _vstart
  if diff == 0 then
    return vim.api.nvim_buf_line_count(0)
  end

  if diff < 0 then
    diff = -diff
  end

  return diff
end

CUTIL.FILE_INFO = function (_)
  local type_info = {
    lua = CUTIL.LINE_COUNT,
  }
  local bufnr = vim.fn.bufnr()
  local t = vim.filetype.match { buf = bufnr }
  local fn = type_info[t]

  if fn then
    return fn()
  end

  return ''
end
