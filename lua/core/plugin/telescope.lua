local builtin = require 'telescope.builtin'
local themes = require 'telescope.themes'

local M = {}

---@alias TelescopeStyle 'dropdown'|'bottom'|'main'

---@type { [TelescopeStyle]: table }
M.style = {}

M.style.dropdown = themes.get_dropdown {
  width = 0.8,
  previewer = false,
  prompt_title = false
}

M.style.bottom = themes.get_ivy {
  -- border = true,
  preview = true,
  shorten_path = true,
  hidden = true,
  prompt_title = '',
  preview_title = '',
  borderchars = {
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
}

M.style.main = {
  -- winblend = 20;
  width = 0.8,
  show_line = false,
  results_title = '',
  prompt_prefix = '$ ',
  prompt_position = 'top',
  prompt_title = '',
  preview_title = '',
  preview_width = 0.4,
}

---@param name TelescopeStyle
---@param opts table
M.get_style = function(name, opts)
  opts = opts or {}
  local style = M.style[name]
  return style and vim.tbl_deep_extend('force', style, opts)
end

M.picker = {}

function M.picker.find_files(props)
  props = props or {}
  local opts = MT(M.style.main, {
    prompt_prefix = core.icons.item.find .. ' ',
    shorten_path = true,
    hidden = true,
  })

  builtin.find_files(MT(opts, props))
end

function M.picker.grep(props)
  props = props or {}
  local opts = MT(M.style.main, {
    max_results = 20
  })

  builtin.live_grep(MT(opts, props))
end

-- Explorer

function M.picker.explorer(props)
  props = props or {}
  local opts = M.style.bottom
  opts = MT(M.style.dropdown, {
    preview = true,
    shorten_path = true,
    hidden = true,
    prompt_title = '',
    preview_title = '',
  })

  builtin.find_files(MT(opts, props))
end

function M.picker.git_files(props)
  props = props or {}
  local opts = M.style.bottom

  builtin.git_files(MT(opts, props))
end

function M.picker.config_files()
  M.pickers.explorer({
    cwd = '~/.config/nvim',
  })
end

function M.picker.notes()
  M.pickers.explorer({
    cwd = '~/.notes',
  })
end

function M.picker.symbols(props)
  props = props or {}
  local opts = MT(M.style.main, {
    shorten_path = true,
    hidden = true,
  })

  builtin.lsp_document_symbols(MT(opts, props))
end

function M.picker.grep_current_file(props)
  props = props or {}
  local opts = MT(M.style.main, {})

  R 'telescope.builtin'.current_buffer_fuzzy_find(MT(opts, props))
end

return M
