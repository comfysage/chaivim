-- adapted from @NvChad https://github.com/NvChad/ui/blob/v2.0/lua/nvchad/nvdash/init.lua

local M = {}
local api = vim.api
local fn = vim.fn

---@class DashConfig
---@field open_on_startup boolean
---@field header string[]
---@field buttons { [1]: string, [2]: string, [3]: string|function }[]

local default_config = {
  open_on_startup = true,
  header = {
    [[      )  (      ]],
    [[     (   ) )    ]],
    [[      ) ( (     ]],
    [[           )    ]],
    [[   ▟██████████▙ ]],
    [[ █▛██▛ ▟▛ ▟▛ ▟█ ]],
    [[ ▜▙█▛ ▟▛ ▟▛ ▟██ ]],
    [[   ▝██████████▛ ]],
    [[    ▝▀▀▀▀▀▀▀▀▀  ]],
  },
  buttons = {
    { 'find files', 'SPC SPC', function() require 'core.plugin.telescope'.space() end },
    { 'select theme', 'CTRL t', function() require 'telescope.builtin'.colorscheme() end }
  },
}

api.nvim_create_autocmd("BufLeave", {
  group = core.group_id,
  callback = function()
    if vim.bo.ft == "dash" then
      vim.g.dash_displayed = false
    end
  end,
})

vim.api.nvim_set_hl(0, "DashAscii", { link = 'TablineSel' })
vim.api.nvim_set_hl(0, "DashButtons", { link = 'Comment' })

---@param opts DashConfig
function M.open(opts)
  local config = vim.tbl_deep_extend('force', default_config, opts)
  -- setup variables
  local headerAscii = config.header
  local emmptyLine = string.rep(" ", fn.strwidth(headerAscii[1]))

  table.insert(headerAscii, 1, emmptyLine)
  table.insert(headerAscii, 2, emmptyLine)

  headerAscii[#headerAscii + 1] = emmptyLine
  headerAscii[#headerAscii + 1] = emmptyLine

  local min_width = 36
  local dashWidth = #headerAscii[1] + 3
  if dashWidth < min_width then
    dashWidth = min_width
  end

  local max_height = #headerAscii + 4 + (2 * #config.buttons) -- 4  = extra spaces i.e top/bottom
  local get_win_height = api.nvim_win_get_height

  -- create buffer
  local buf = api.nvim_create_buf(false, true)
  local win = api.nvim_get_current_win()

  -- switch to larger win if cur win is small
  if dashWidth + 6 > api.nvim_win_get_width(0) then
    api.nvim_set_current_win(api.nvim_list_wins()[2])
    win = api.nvim_get_current_win()
  end

  api.nvim_win_set_buf(win, buf)

  vim.opt_local.filetype = "dash"
  vim.g.dash_displayed = true

  local header = headerAscii
  local buttons = config.buttons

  local function addSpacing_toBtns(txt1, txt2)
    local btn_len = fn.strwidth(txt1) + fn.strwidth(txt2)
    local spacing = dashWidth - btn_len
    return txt1 .. string.rep(" ", spacing - 1) .. txt2 .. " "
  end

  local function addPadding_toHeader(str)
    local start_padding = (api.nvim_win_get_width(win) - fn.strwidth(str)) / 2
    local end_padding   = (dashWidth - fn.strwidth(str)) / 2 + 1
    return string.rep(" ", math.floor(start_padding)) .. str .. string.rep(" ", math.floor(end_padding))
  end

  local dashboard = {}

  for _, val in ipairs(header) do
    table.insert(dashboard, val .. " ")
  end

  for _, val in ipairs(buttons) do
    table.insert(dashboard, addSpacing_toBtns(val[1], val[2]) .. " ")
    table.insert(dashboard, header[1] .. " ")
  end

  local result = {}

  -- make all lines available
  for i = 1, math.max(get_win_height(win), max_height) do
    result[i] = ""
  end

  local headerStart_Index = math.abs(math.floor((get_win_height(win) / 2) - (#dashboard / 2))) +
      1 -- 1 = To handle zero case
  local abc = math.abs(math.floor((get_win_height(win) / 2) - (#dashboard / 2))) +
      1 -- 1 = To handle zero case

  -- set ascii
  for _, val in ipairs(dashboard) do
    result[headerStart_Index] = addPadding_toHeader(val)
    headerStart_Index = headerStart_Index + 1
  end

  api.nvim_buf_set_lines(buf, 0, -1, false, result)

  local dash = api.nvim_create_namespace "dash"
  local horiz_pad_index = math.floor((api.nvim_win_get_width(win) / 2) - (dashWidth / 2)) - 2

  for i = abc, abc + #header - 3 do
    api.nvim_buf_add_highlight(buf, dash, "DashAscii", i, horiz_pad_index, -1)
  end

  for i = abc + #header - 2, abc + #dashboard do
    api.nvim_buf_add_highlight(buf, dash, "DashButtons", i, horiz_pad_index, -1)
  end

  api.nvim_win_set_cursor(win, { abc + #header, math.floor((vim.o.columns - dashWidth) / 2) - 2})

  local first_btn_line = abc + #header + 2
  local keybind_lineNrs = {}

  for _, _ in ipairs(config.buttons) do
    table.insert(keybind_lineNrs, first_btn_line - 2)
    first_btn_line = first_btn_line + 2
  end

  vim.keymap.set("n", "q", ":quit<cr>", { buffer = true })
  vim.keymap.set("n", "h", "", { buffer = true })
  vim.keymap.set("n", "<Left>", "", { buffer = true })
  vim.keymap.set("n", "l", "", { buffer = true })
  vim.keymap.set("n", "<Right>", "", { buffer = true })
  vim.keymap.set("n", "<Up>", "", { buffer = true })
  vim.keymap.set("n", "<Down>", "", { buffer = true })

  vim.keymap.set("n", "k", function()
    local cur = fn.line "."
    local target_line = cur == keybind_lineNrs[1] and keybind_lineNrs[#keybind_lineNrs] or cur - 2
    api.nvim_win_set_cursor(win, { target_line, math.floor((vim.o.columns - dashWidth) / 2) - 2 })
  end, { buffer = true })

  vim.keymap.set("n", "j", function()
    local cur = fn.line "."
    local target_line = cur == keybind_lineNrs[#keybind_lineNrs] and keybind_lineNrs[1] or cur + 2
    api.nvim_win_set_cursor(win, { target_line, math.floor((vim.o.columns - dashWidth) / 2) - 2 })
  end, { buffer = true })

  -- pressing enter on
  vim.keymap.set("n", "<CR>", function()
    for i, val in ipairs(keybind_lineNrs) do
      if val == fn.line "." then
        local action = config.buttons[i][3]

        if type(action) == "string" then
          vim.cmd(action)
        elseif type(action) == "function" then
          action()
        end
      end
    end
  end, { buffer = true })

  -- buf only options
  vim.opt_local.buflisted = false
  vim.opt_local.modifiable = false
  vim.opt_local.number = false
  vim.opt_local.list = false
  vim.opt_local.relativenumber = false
  vim.opt_local.wrap = false
  vim.opt_local.cul = false
  vim.opt_local.colorcolumn = "0"
end

return M
