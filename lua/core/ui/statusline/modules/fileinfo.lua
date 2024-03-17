local utils = require 'core.ui.statusline.utils'

return function()
  local icon = "󰈚"
  local path = vim.api.nvim_buf_get_name(utils.stbufnr())
  local name = (path == "" and "empty") or path:match "([^/\\]+)[/\\]*$"

  if name ~= "empty" and core.config.ui.devicons then
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      if ft_icon then
        icon = ft_icon
      end
    end
  end

  return core.lib.fmt.space(icon) .. name .. " "
end
