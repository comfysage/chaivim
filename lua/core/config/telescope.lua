local Util = require 'core.utils'

local M = {}

local function use_theme(theme_name)
  local themes = {
    minimal = {
      borderchars = {
        { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        prompt = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      },
      highlights = {
        TelescopeTitle = { core.hl.ui.accent },
        TelescopeNormal = { core.hl.ui.bg },
        TelescopePromptNormal = { core.hl.ui.bg_accent },
        TelescopeSelection = { core.hl.ui.current },
      },
    },
    main = {
      borderchars = {
        { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        prompt = { " ", "│", "─", "│", '│', '│', "╯", "╰" },
        results = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
        preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      },
      highlights = {
        TelescopeTitle = { core.hl.ui.accent, { reverse = true } },
        TelescopeNormal = { core.hl.ui.bg },
        TelescopePromptNormal = { core.hl.ui.bg_accent },
        TelescopeSelection = { core.hl.ui.current },
      },
    },
  }

  if not theme_name then
    return
  end
  vim.api.nvim_set_hl(0, 'Telescope', {})

  local theme = themes[theme_name]
  if not theme then
    Util.log('theme with name `' .. theme_name .. '` not found', 'error')
    return
  end

  require 'telescope'.setup {
    defaults = {
      borderchars = theme.borderchars,
    },
  }

  for hl_name, hl_v in pairs(theme.highlights) do
    local hl_group = hl_v[1]
    if hl_v[2] then
      hl_group = vim.tbl_extend('force', hl_group, hl_v[2])
    end
    hl_group.name = nil

    vim.api.nvim_set_hl(0, hl_name, hl_group)
  end
end

---@class CoreTelescopeOpts
---@field config TelescopeConfig
---@field use_fzf boolean
---@field theme 'main'|'minimal'
---@field mappings { [string]: string }

---@param opts CoreTelescopeOpts
M.setup = function(opts)
  require 'telescope'.setup(opts.config)

  if opts.use_fzf then
    require 'core.bootstrap'.boot 'telescope_fzf'
    require 'telescope'.load_extension 'fzf'
  end

  if opts.theme and type(opts.theme) == 'string' then
    require 'core.load.handle'.create {
      event = 'ColorScheme', priority = 5,
      fn = function(_)
        use_theme(core.modules.core.telescope.opts.theme)
      end
    }
  end

  Keymap.group {
    group = 'telescope',
    { 'normal', opts.mappings.find_files,       function() require 'core.plugin.telescope'.picker.find_files {} end,  'find files' },
    { 'normal', opts.mappings.live_grep,        function() require 'core.plugin.telescope'.picker.grep {} end,        'find string' },
    { 'normal', opts.mappings.simple_find_file, function() require 'core.plugin.telescope'.picker.explorer {} end,    'find file' },
    { 'normal', opts.mappings.search,           function() R 'core.plugin.telescope'.picker.grep_current_file {} end, 'find in file' },
    { 'normal', opts.mappings.symbols,          function() require 'core.plugin.telescope'.picker.symbols {} end,     'find symbols' },
    { 'normal', opts.mappings.git_files,        function() require 'core.plugin.telescope'.picker.git_files {} end,   'find git file' },
    { 'normal', opts.mappings.buffers,          function() require 'telescope.builtin'.buffers() end,                 'find buffer' },
    { 'normal', opts.mappings.filetypes,        function() require 'telescope.builtin'.filetypes() end,               'find filetype' },
    { 'normal', opts.mappings.keymaps,          function() require 'telescope.builtin'.keymaps() end,                 'find keymap' },
    { 'normal', opts.mappings.help_tags,        function() require 'telescope.builtin'.help_tags() end,               'find help tag' },
    { 'normal', opts.mappings.colorscheme,      function() require 'telescope.builtin'.colorscheme() end,             'find colorscheme' },
    { 'normal', opts.mappings.quickfix,         function() require 'telescope.builtin'.quickfix() end,                'search in qf list' },
  }
end

return M
