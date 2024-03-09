return {
  { 'comfysage/keymaps.nvim' },
  { 'comfysage/base46',
    cond = function() return core.lib.options:get('ui', 'general', 'colorscheme') ~= nil and core.config.colorscheme == 'base46' end },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
  },
  { 'nvim-lualine/lualine.nvim',
    cond = function() return core.lib.options:enabled 'lualine' end },
  { 'comfysage/evergarden' },
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
  { name = 'luasnip', 'L3MON4D3/LuaSnip',
    cond = function() return core.lib.options:enabled 'luasnip' end,
    version = 'v2.*',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
  },
  { 'echasnovski/mini.nvim' },
  { 'lewis6991/gitsigns.nvim' },
  { 'folke/which-key.nvim',
    cond = function() return core.lib.options:enabled 'whichkey' end },
  { 'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    cond = function() return core.lib.options:enabled 'todo_comments' end },
  { import = core.modules.core.lazy.opts.module },
}
