return {
  setup = function(opts)
    require 'core.bootstrap'.boot 'gitsigns'

    local ok, gs = SR_L 'gitsigns'
    if not ok then
      return
    end

    local signs = {
        add          = { hl = 'GitSignsAdd', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    }
    for k, _ in pairs(signs) do
      local _first = string.sub(k, 1, 1)
      local hl_name = string.format('GitSigns%s%s', _first:upper(), k:sub(2))
      signs[k] = {
        hl     = hl_name,
        numhl  = string.format('%sNr', hl_name),
        linehl = string.format('%sLn', hl_name),
      }
    end
    signs.untracked    = signs.add
    signs.changedelete = signs.change
    signs.topdelete    = signs.delete
    for k, v in pairs(signs) do
      opts.config.signs[k] = vim.tbl_deep_extend('force', opts.config.signs[k], v)
    end
    require 'core.plugin.highlight'.apply {
      GitSignsAdd    = {},
      GitSignsChange = {},
      GitSignsDelete = {},
    }

    gs.setup(opts.config)
  end,
}
