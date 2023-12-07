return {
  { name = 'sentinel', 'crispybaccoon/sentinel.nvim', enabled = false },
  { name = 'keymaps', 'crispybaccoon/keymaps.nvim' },
  { name = 'plenary', 'nvim-lua/plenary.nvim' },
  { name = 'telescope', 'nvim-telescope/telescope.nvim' },
  { import = core.modules.core.lazy.opts.module },
}
