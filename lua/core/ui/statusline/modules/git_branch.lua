local utils = require 'core.ui.statusline.utils'

return function()
  if
      not vim.b[utils.stbufnr()].gitsigns_head
      or vim.b[utils.stbufnr()].gitsigns_git_status
  then
    return ''
  end

  local git_status = vim.b[utils.stbufnr()].gitsigns_status_dict

  local branch_name = core.lib.fmt.space(core.lib.icons.git.branch)
      .. git_status.head

  return branch_name
end
