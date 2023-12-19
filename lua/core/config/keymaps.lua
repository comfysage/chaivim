local Util = require 'core.utils'

_G.Keymap = _G.Keymap or {}

_G.Keymap.group = _G.Keymap.group or function(props)
  if not props.group then
    Util.log('`Keymap.group` requires `group` field', 'warn')
    return
  end
  local mappings = props[1] or {}
  if #props > 1 then
    mappings = props
  end
  for _, map in ipairs(mappings) do
    if #map < 4 then
      Util.log('`Keymap.group` requires 4 paramaters per keymap', 'warn')
      goto continue
    end
    local mode = map[1]
    local lhs = map[2]
    local rhs = map[3]
    local desc = map[4]
    keymaps[mode][lhs] = { rhs, desc, group = props.group }
    ::continue::
  end
end

---@param map string
---@return string
local function lhs_fmt(map)
  local map_str = ''

  local sp_open = 0
  local temp = ''

  local _map = vim.split(map, '')
  local i = 1
  while i <= #_map do
    temp = ''
    if sp_open > 0 then
      if _map[i] == '>' then
        temp = string.sub(map, sp_open, i)
        temp = string.lower(temp)
        for pattern, rpl in pairs(keymaps_config.repl_keys) do
          temp = string.gsub(temp, pattern, rpl)
        end
        sp_open = 0
      end
    else
      temp = _map[i]

      if temp == '<' then
        sp_open = i
        temp = ''
      end
      if i == #_map and sp_open > 0 then
        temp = string.sub(map, sp_open, i)
      end
    end

    if temp and #temp > 0 then
      if #map_str > 0 then
        map_str = map_str .. ' + '
      end
      map_str = map_str .. temp
    end

    i = i+1
  end

  return map_str
end

---@param group_name any
---@param desc_width integer
---@param lhs_width integer
local function generate_group(group_name, desc_width, lhs_width)
  local maps = require 'keymaps.data'.get_group(group_name)
  local str_keys = {}
  for _, map in pairs(maps.normal) do
    local desc = string.sub(map.desc, 0, desc_width)

    local lhs = lhs_fmt(map.lhs)
    lhs = string.sub(lhs, 0, lhs_width)
    str_keys[#str_keys + 1] = { desc, lhs }
  end

  return str_keys
end

return {
  setup = function(opts)
    Util.log(string.format('setting leader to "%s"', vim.g.mapleader))

    local _leader = opts.leader
    if opts.leader == 'space' or opts.leader == 'SPC' then
      _leader = ' '
    end

    vim.g.mapleader = _leader
    vim.g.maplocalleader = _leader

    require 'keymaps'.setup {
      default_opts = opts.defaults,
      special_keys = opts.special_keys
    }
    keymaps_config.repl_keys = {}
    for m, k in pairs(keymaps_config.special_keys) do
      keymaps_config.repl_keys[string.lower(k)] = m
    end
    keymaps_config.repl_keys['<leader>'] = opts.leader
    keymaps_config.repl_keys['<[c]%-([%w])>'] = 'CTRL+%1'
    keymaps_config.repl_keys['<[m]%-([%w])>'] = 'META+%1'
    keymaps_config.repl_keys['<[a]%-([%w])>'] = 'ALT+%1'

    for group, mappings in pairs(opts.mappings) do
      Keymap.group { group = group, mappings }
    end
  end,
  cheatsheet = function(props)
    local api = vim.api
    -- create buffer
    local buf = api.nvim_create_buf(false, true)
    local win = api.nvim_get_current_win()

    api.nvim_win_set_buf(win, buf)

    vim.opt_local.filetype = "cheatsheet"
    vim.g.cheatsheet_displayed = true

    local groups = require 'keymaps.data'.get_groups()
    local gr_i = 1

    --[[
{[1]  {[2]
{''}  {''}
{''}  {''}
{''}  {''}
{''}  {''}
{''}  {''}
{''}  {''}
}     }
    ]]
    --
    local cheatsheet = {}

    local max_width = api.nvim_win_get_width(win)
    local desc_width = 30
    local lhs_width = 12
    local hor_pad = 1
    local spacing = 2
    local group_width = desc_width + lhs_width + (hor_pad * 2) + spacing
    local groups_per_line = math.floor(max_width / group_width)
    local max_groups_per_col = math.ceil(#groups / groups_per_line)

    local win_height = api.nvim_win_get_height(win)

    local cur_gr_in_line = 1
    while cur_gr_in_line <= groups_per_line and gr_i <= #groups do
      cheatsheet[cur_gr_in_line] = {}

      local local_gr_i = 1
      local y = 0
      while y < win_height and gr_i <= #groups and local_gr_i <= max_groups_per_col do
        local name = groups[gr_i]
        local str_keys = generate_group(name, desc_width, lhs_width)
        if #str_keys > 0 then
          local section = {}

          local gr_len = vim.fn.strwidth(name)
          local gr_space = group_width - gr_len
          local gr_padding = { math.floor(gr_space / 2), math.ceil(gr_space / 2) }
          local gr_header = string.rep(' ', gr_padding[1]) .. name .. string.rep(' ', gr_padding[2])

          section[1] = gr_header
          section[2] = string.rep(' ', group_width)

          for _, str_tuple in ipairs(str_keys) do
            local desc = str_tuple[1] .. string.rep(' ', desc_width - vim.fn.strwidth(str_tuple[1]))
            local lhs = string.rep(' ', lhs_width - vim.fn.strwidth(str_tuple[2])) .. str_tuple[2]
            section[#section + 1] = string.rep(' ', hor_pad) ..
                desc .. string.rep(' ', spacing) .. lhs .. string.rep(' ', hor_pad)
          end

          local i = #cheatsheet[cur_gr_in_line]
          local j = 1
          while j <= #section do
            y = i + j
            cheatsheet[cur_gr_in_line][y] = section[j]
            j = j + 1
          end
          y = y + 1
          cheatsheet[cur_gr_in_line][y] = string.rep(' ', group_width)

          local_gr_i = local_gr_i + 1
        end

        -- end
        gr_i = gr_i + 1
      end

      -- end
      cur_gr_in_line = cur_gr_in_line + 1
    end

    local result = {}

    -- make all lines available
    for i = 1, win_height do
      result[i] = ""
    end

    local y = 1
    local not_empty = true
    while not_empty do
      not_empty = false
      local line = ''
      for _, column in ipairs(cheatsheet) do
        local row = column[y]
        if row and vim.fn.strwidth(row) > 0 then
          not_empty = true
          line = line .. row
        else
          line = line .. string.rep(' ', group_width)
        end
      end
      result[y] = line
      y = y + 1
    end

    api.nvim_buf_set_lines(buf, 0, -1, false, result)

    vim.keymap.set("n", "q", function() vim.api.nvim_buf_delete(buf, { force = true }) end, { buffer = true })

    -- buf only options
    vim.opt_local.buflisted = false
    vim.opt_local.modifiable = false
    vim.opt_local.number = false
    vim.opt_local.list = false
    vim.opt_local.relativenumber = false
    vim.opt_local.wrap = false
    vim.opt_local.cul = false
    vim.opt_local.colorcolumn = "0"
  end,
  fmt = lhs_fmt,
}
