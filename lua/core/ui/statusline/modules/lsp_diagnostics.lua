local utils = require 'core.ui.statusline.utils'

return function()
  local errors = #vim.diagnostic.get(
    utils.stbufnr(),
    { severity = vim.diagnostic.severity.ERROR }
  )
  local warnings = #vim.diagnostic.get(
    utils.stbufnr(),
    { severity = vim.diagnostic.severity.WARN }
  )
  local info = #vim.diagnostic.get(
    utils.stbufnr(),
    { severity = vim.diagnostic.severity.INFO }
  )
  local hints = #vim.diagnostic.get(
    utils.stbufnr(),
    { severity = vim.diagnostic.severity.HINT }
  )

  local error_str = ''
  if errors and errors > 0 then
    error_str = '%#St_lspError#' .. core.lib.fmt.space(core.lib.icons.diagnostic.error) .. errors .. ' '
  end
  local warning_str = ''
  if warnings and warnings > 0 then
    warning_str = '%#St_lspWarning#' .. core.lib.fmt.space(core.lib.icons.diagnostic.warn) .. warnings .. ' '
  end
  local info_str = ''
  if info and info > 0 then
    info_str = '%#St_lspInfo#' .. core.lib.fmt.space(core.lib.icons.diagnostic.info) .. info .. ' '
  end
  local hint_str = ''
  if hints and hints > 0 then
    hint_str = '%#St_lspHints#' .. core.lib.fmt.space(core.lib.icons.diagnostic.hint) .. hints .. ' '
  end

  return error_str .. warning_str .. hint_str .. info_str
end
