local M = {}

---@class OptionsConfig
---@field cursorline boolean
---@field tab_width integer
---@field scrolloff integer
---@field use_ripgrep boolean
---@field treesitter_folds boolean

--- Setup options
---@param opts OptionsConfig
function M.setup(opts)
  vim.opt.encoding = 'utf-8'
  vim.opt.fileencoding = 'utf-8'

  -- basic UI
  vim.opt.errorbells = false
  vim.opt.mouse = 'nv'

  vim.opt.cursorline = opts.cursorline or false
  vim.opt.showmode = false
  vim.opt.showcmd = false

  vim.opt.relativenumber = false
  vim.opt.number = true
  vim.opt.numberwidth = 3
  vim.opt.signcolumn = 'yes:1'
  vim.opt.smarttab = true

  vim.opt.pumheight = 5
  vim.opt.wildoptions = { 'fuzzy', 'pum', 'tagfile' }
  vim.opt.wildmode = 'longest:full,full'

  vim.opt.conceallevel = 2
  vim.opt.concealcursor = 'c'

  vim.opt.shortmess = 'filnrxoOtTIF'

  vim.o.timeout = true
  vim.o.timeoutlen = 300

  -- indention
  vim.opt.cindent = true
  vim.opt.smartindent = true

  -- no tab indention
  local tab_width = opts.tab_width or 2
  vim.opt.tabstop = tab_width
  vim.opt.softtabstop = 1
  vim.opt.shiftwidth = tab_width
  vim.opt.expandtab = true

  -- Lifecycle
  vim.opt.shell = vim.fn.getenv('SHELL') or '/usr/bin/bash'
  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.cmd [[ set undodir=~/.undodir ]]
  vim.opt.undofile = true
  vim.opt.hidden = true

  -- Searching
  vim.opt.grepprg = opts.use_ripgrep and 'rg --vimgrep' or 'grep -n $* /dev/null'
  vim.opt.grepformat = '%f:%l:%c:%m'
  vim.opt.incsearch = true
  vim.opt.hlsearch = false
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Scrolling
  vim.opt.scrolloff = opts.scrolloff or 2

  -- Folding
  vim.opt.foldenable = true
  vim.opt.foldlevelstart = 0
  vim.opt.foldnestmax = 4
  vim.opt.foldmethod = 'marker'
  if opts.treesitter_folds then
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldenable = false
  end

  -- window splits
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  for _, option in ipairs({ 'menu', 'menuone', 'noselect', 'preview' }) do
    if not vim.tbl_contains(vim.opt.completeopt, option) then
      vim.opt.completeopt:append(option)
    end
  end

  -- by default unload all vim plugins
  vim.g.loaded_zipPlugin         = 1
  vim.g.loaded_zip               = 1
  vim.g.loaded_tarPlugin         = 1
  vim.g.loaded_tar               = 1
  vim.g.loaded_gzip              = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_matchit           = 1
end

return M
