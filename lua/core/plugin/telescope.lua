local builtin = require 'telescope.builtin'
local themes = require 'telescope.themes'

local M = {}

M.style = {}

M.style.dropdown = themes.get_dropdown {
  borderchars = {
    --[[ { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'}, ]]
    { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    prompt = { "─", "│", " ", "│", '╭', '╮', "│", "│" },
    results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
    preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  },
  width = 0.8,
  previewer = false,
  prompt_title = false
}

M.style.bottom = themes.get_ivy {
  -- border = true,
  preview = true,
  shorten_path = true,
  hidden = true,
  prompt_title = '',
  preview_title = '',
  borderchars = {
    -- preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
}

M.style.main = {
  -- winblend = 20;
  width = 0.8,
  show_line = false,
  results_title = '',
  prompt_prefix = '$ ',
  prompt_position = 'top',
  prompt_title = '',
  preview_title = '',
  preview_width = 0.4,
  borderchars = {
    --[[ { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {" ", "│", "─", "│", '│', '│', "┘", "└"},
      results = {"─", "│", " ", "│", "┌", "┐", "│", "│"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'}, ]]
    -- '<,'>s/└/╰/g | '<,'>s/┘/╯/g | '<,'>s/┐/╮/g | '<,'>s/┌/╭/g
    { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    prompt = { " ", "│", "─", "│", '│', '│', "╯", "╰" },
    results = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
    preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  },
}

M.picker = {}

function M.picker.find_files(props)
  props = props or {}
  local opts = MT(M.style.main, {
    shorten_path = true,
    hidden = true,
  })

  builtin.find_files(MT(opts, props))
end

function M.picker.grep(props)
  props = props or {}
  local opts = MT(M.style.main, {
    max_results = 20
  })

  builtin.live_grep(MT(opts, props))
end

-- Explorer

function M.picker.explorer(props)
  props = props or {}
  local opts = M.style.bottom
  opts = MT(M.style.dropdown, {
    preview = true,
    shorten_path = true,
    hidden = true,
    prompt_title = '',
    preview_title = '',
  })

  builtin.find_files(MT(opts, props))
end

function M.picker.git_files(props)
  props = props or {}
  local opts = M.style.bottom

  builtin.git_files(MT(opts, props))
end

function M.picker.config_files()
  M.pickers.explorer({
    cwd = '~/.config/nvim',
  })
end

function M.picker.notes()
  M.pickers.explorer({
    cwd = '~/.notes',
  })
end

function M.picker.symbols(props)
  props = props or {}
  local opts = MT(M.style.main, {
    shorten_path = true,
    hidden = true,
  })

  builtin.lsp_document_symbols(MT(opts, props))
end

function M.picker.grep_current_file(props)
  props = props or {}
  local opts = MT(M.style.main, {})

  R 'telescope.builtin'.current_buffer_fuzzy_find(MT(opts, props))
end

---@alias TelescopeConfig {}

---@type TelescopeConfig
local default_config = {
  defaults = {
    prompt_prefix = '$ ',
    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
    path_display = nil,
    file_ignore_patterns = { 'node_modules', '%.git/' },
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { "─", "│", "─", "│", '┌', '┐', "┘", "└" },
      results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
    --[[ borderchars = {
      prompt = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' };
      results = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' };
      preview = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' };
    }; ]]
  },
  extensions = {
    fzf = {
      fuzzy = true,                         -- false will only do exact matching
      override_generic_sorter = true,       -- override the generic sorter
      override_file_sorter = true,          -- override the file sorter
      case_mode = 'smart_case',             -- or 'ignore_case' or 'respect_case', defaults to 'smart_case'
    },
  },
  pickers = {
    find_files = {
      disable_devicons = false,
    },
  },
}

---@class CoreTelescopeOpts
---@field config TelescopeConfig

---@param opts CoreTelescopeOpts
M.setup = function(opts)
  local config = vim.tbl_deep_extend('force', default_config, opts.config)

  require 'telescope'.setup (config)

  if config.use_fzf then
    require 'telescope'.load_extension 'fzf'
  end
end

return M
