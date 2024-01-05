local M = {}

M.setup_highlights = function()
  core.lib.autocmd.create {
    event = 'ColorScheme', priority = 20,
    fn = function(_)
      require 'core.ui.statusline.hl'.apply_highlights()
    end
  }
end

M.apply_highlights = function()
  local normal_bg = core.lib.hl:get('ui', 'bg').bg
  local normal_fg = core.lib.hl:get('ui', 'fg').fg

  local accent_bg = core.lib.hl:get('ui', 'border').fg
  local comment_fg = core.lib.hl:get('ui', 'comment').fg

  local hls = {
    ['St_normal'] = { fg = normal_fg, bg = core.lib.hl:get('ui', 'bg_accent').bg },
  }
  local modes = {
    ['St_NormalMode'] = { fg = normal_bg, bg = core.lib.hl:get('ui', 'accent').bg },
    ['St_VisualMode'] = { fg = normal_bg, bg = core.lib.hl:get('syntax', 'constant').fg },
    ['St_InsertMode'] = { fg = normal_bg, bg = core.lib.hl:get('ui', 'focus').fg },
    ['St_ReplaceMode'] = { link = 'St_InsertMode' },
    ['St_SelectMode'] = { link = 'St_VisualMode' },
    ['St_CommandMode'] = { link = 'St_NormalMode' },
    ['St_TerminalMode'] = { link = 'St_NormalMode' },
    ['St_NTerminalMode'] = { link = 'St_TerminalMode' },
    ['St_ConfirmMode'] = { link = 'St_CommandMode' },
  }
  hls = vim.tbl_deep_extend('force', hls, modes)

  local sections = {
    ['St_section_b'] = { bg = accent_bg },
    ['St_section_c'] = { fg = comment_fg, bg = normal_bg },
    ['St_section_x'] = { fg = comment_fg, bg = normal_bg },
    ['St_section_y'] = { bg = accent_bg },
  }
  hls = vim.tbl_deep_extend('force', hls, sections)
  local sections_sep = {
    ['St_section_b_sep'] = { fg = sections['St_section_b'].bg, bg = sections['St_section_c'].bg },
    ['St_section_y_sep'] = { fg = sections['St_section_y'].bg, bg = sections['St_section_x'].bg },
  }
  hls = vim.tbl_deep_extend('force', hls, sections_sep)

  local modes_sep = {
    ['St_NormalModeSep'] = { fg = modes['St_NormalMode'].bg, bg = sections['St_section_b'].bg },
    ['St_VisualModeSep'] = { fg = modes['St_VisualMode'].bg, bg = sections['St_section_b'].bg },
    ['St_InsertModeSep'] = { fg = modes['St_InsertMode'].bg, bg = sections['St_section_b'].bg },
    ['St_ReplaceModeSep'] = { link = 'St_InsertModeSep' },
    ['St_SelectModeSep'] = { link = 'St_VisualModeSep' },
    ['St_CommandModeSep'] = { link = 'St_NormalModeSep' },
    ['St_TerminalModeSep'] = { link = 'St_NormalModeSep' },
    ['St_NTerminalModeSep'] = { link = 'St_TerminalModeSep' },
    ['St_ConfirmModeSep'] = { link = 'St_CommandModeSep' },
  }
  hls = vim.tbl_deep_extend('force', hls, modes_sep)

  core.lib.hl.apply(hls)
end

return M
