return {
  setup = function(opts)
    -- termguicolors
    vim.opt.termguicolors = true
    -- foldcolumn off
    vim.opt.foldcolumn = "0"
    -- global statusline
    vim.opt.laststatus = 3

    -- fold chars
    vim.opt.fillchars:append { fold = " ", foldclose = ">" }
    -- endofbuffer chars
    vim.opt.fillchars:append { eob = " " }

    vim.opt.listchars:append { tab = "> ", trail = "-", nbsp = "+", space = "·" }

    vim.opt.background = "dark"

    vim.cmd([[ command! Highlights source $VIMRUNTIME/syntax/hitest.vim ]])

    if opts.fix then
      vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
        group = core.group_id,
        callback = function()
          opts.fix()
        end
      })
    end
  end
}
