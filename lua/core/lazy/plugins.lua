return {
  { name = 'chai', 'crispybaccoon/chaivim', enabled = false },
  { name = 'keymaps', 'crispybaccoon/keymaps.nvim' },
  { name = 'plenary', 'nvim-lua/plenary.nvim' },
  { name = 'telescope', 'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'sharkdp/fd',
    },
  },
  { name = 'lualine', 'nvim-lualine/lualine.nvim' },
  { name = 'evergarden', 'crispybaccoon/evergarden' },
  { import = core.modules.core.lazy.opts.module },
}
