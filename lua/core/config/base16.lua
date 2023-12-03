return {
  setup = function(opts)
    vim.api.nvim_create_user_command('SelectTheme', function()
      require 'core.plugin.base16'.select()
    end, {})
    if opts.colorscheme then
      vim.defer_fn(function()
        require 'core.plugin.base16'.load(opts.colorscheme)
      end, 0)
    end
  end
}
