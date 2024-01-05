local utils = require 'core.ui.statusline.utils'

return function()
  local icon = " 󰈚 "
  local path = vim.api.nvim_buf_get_name(utils.stbufnr())
  local name = (path == "" and "empty ") or path:match "([^/\\]+)[/\\]*$"

  if name ~= "Empty " then
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and " " .. ft_icon) or icon
    end

    name = " " .. name .. " "
  end

  return icon .. name
end
