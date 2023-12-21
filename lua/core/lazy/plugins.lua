return {
  { name = 'chai', 'crispybaccoon/chaivim' },
  { 'crispybaccoon/keymaps.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
  },
  { 'nvim-lualine/lualine.nvim' },
  { 'crispybaccoon/evergarden' },
  { 'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
  },
  {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' },
  },
  { 'neovim/nvim-lspconfig' },
  { 'echasnovski/mini.nvim' },
  { import = core.modules.core.lazy.opts.module },
}
