local utils = require 'core.ui.statusline.utils'

return function()
  local clients = vim.lsp.get_clients({ bufnr = utils.stbufnr() })
  local null = {}
  local lsp = {}
  for _, client in ipairs(clients) do
    if client.name == 'null-ls' then
      null[#null+1] = client.name
    else
      lsp[#lsp+1] = client.name
    end
  end

  local client = nil
  if #lsp == 0 then
    if #null > 0 then
      client = null[1]
    end
  else
    client = lsp[1]
  end
  if client then
    local str = '%#St_LspStatus#'
    if vim.o.columns > 100 then
      str = str .. core.lib.fmt.space('') .. 'lsp' .. core.lib.fmt.space(core.lib.icons.ui.item_prefix) .. client .. ' '
    else
      str = str .. core.lib.fmt.space('') .. 'lsp' .. ' '
    end
    return str
  end
end
