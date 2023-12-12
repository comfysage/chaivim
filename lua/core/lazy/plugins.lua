return {
  { name = 'chai', 'crispybaccoon/chaivim' },
  { 'crispybaccoon/keymaps.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'sharkdp/fd',
    },
  },
  { 'nvim-lualine/lualine.nvim' },
  { 'crispybaccoon/evergarden' },
  { 'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
  },
  { 'echasnovski/mini.nvim' },
  { import = core.modules.core.lazy.opts.module },
}
