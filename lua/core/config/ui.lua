local Util = require 'core.utils'

return {
  setup = function(opts)
    Util.log('ui.setup', 'set up ui')

    if opts.input.enabled then
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require 'core.ui.input' (...)
      end
    end

    if opts.cursor.enabled then
      require 'core.ui.cursor'.setup()
    end

    if opts.statusline.enabled then
      ---@diagnostic disable-next-line: inject-field
      core.modules.core.lualine.enabled = false

      require 'core.ui.statusline.hl'.setup_highlights()
      ---@class core.types.global
      ---@field statusline fun()
      _G.core.statusline = function()
        return R 'core.ui.statusline'.run()
      end
      vim.opt.statusline = "%!v:lua.core.statusline()"
    end

    if opts.bufferline.enabled then
      require 'core.ui.bufferline.load'.setup()

      ---@class core.types.global
      ---@field bufferline fun()
      _G.core.bufferline = function()
        vim.opt.showtabline = 2
        return R 'core.ui.bufferline.modules'.run()
      end
      vim.opt.tabline = "%!v:lua.core.bufferline()"
    end

    if opts.terminal.enabled then
      require 'core.ui.term'.setup(opts.terminal)
    end
  end,
}
