---@class vim.var_accessor
---@field statusline_winid integer

local utils = {}

function utils.stwinid()
  return vim.g.statusline_winid or 0
end

function utils.stbufnr()
  return vim.api.nvim_win_get_buf(utils.stwinid())
end

function utils.is_activewin()
  return vim.api.nvim_get_current_win() == utils.stwinid()
end

---@type { [NvMode]: { [1]: string, [2]: string } }
utils.modes = {
  ["n"] = { "NORMAL", "St_NormalMode" },
  ["no"] = { "NORMAL (no)", "St_NormalMode" },
  ["nov"] = { "NORMAL (nov)", "St_NormalMode" },
  ["noV"] = { "NORMAL (noV)", "St_NormalMode" },
  ["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
  ["niI"] = { "NORMAL i", "St_NormalMode" },
  ["niR"] = { "NORMAL r", "St_NormalMode" },
  ["niV"] = { "NORMAL v", "St_NormalMode" },
  ["nt"] = { "NTERMINAL", "St_NTerminalMode" },
  ["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

  ["v"] = { "VISUAL", "St_VisualMode" },
  ["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
  ["V"] = { "V-LINE", "St_VisualMode" },
  ["Vs"] = { "V-LINE", "St_VisualMode" },
  ['\22'] = { "V-BLOCK", "St_VisualMode" },

  ["i"] = { "INSERT", "St_InsertMode" },
  ["ic"] = { "INSERT (completion)", "St_InsertMode" },
  ["ix"] = { "INSERT completion", "St_InsertMode" },

  ["t"] = { "TERMINAL", "St_TerminalMode" },

  ["R"] = { "REPLACE", "St_ReplaceMode" },
  ["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
  ["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
  ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
  ["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

  ["s"] = { "SELECT", "St_SelectMode" },
  ["S"] = { "S-LINE", "St_SelectMode" },
  ['\19'] = { "S-BLOCK", "St_SelectMode" },
  ["c"] = { "COMMAND", "St_CommandMode" },
  ["cv"] = { "COMMAND", "St_CommandMode" },
  ["ce"] = { "COMMAND", "St_CommandMode" },
  ["r"] = { "PROMPT", "St_ConfirmMode" },
  ["rm"] = { "MORE", "St_ConfirmMode" },
  ["r?"] = { "CONFIRM", "St_ConfirmMode" },
  ["x"] = { "CONFIRM", "St_ConfirmMode" },
  ["!"] = { "SHELL", "St_TerminalMode" },
}

---@param mode? NvMode
---@return { label: string, name: string, hl: string, sep_hl: string }
function utils.getmode(mode)
  if not _G.nvmode then return utils.getmode 'n' end
  if not mode then mode = _G.nvmode end

  local mode_label = utils.modes[mode][1]
  local mode_name = utils.modes[mode][2]
  local mode_hl = "%#" .. mode_name .. "#"
  local mode_sep = "%#" .. mode_name .. "Sep" .. "#"

  return {
    label = mode_label,
    name = mode_name,
    hl = mode_hl,
    sep_hl = mode_sep,
  }
end

return utils
