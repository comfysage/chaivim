return {
  default = {
    opts = {
      config = {
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
        },
        extensions = {
          fzf = {
            fuzzy = true,             -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or 'ignore_case' or 'respect_case', defaults to 'smart_case'
          },
        },
        pickers = {
          find_files = {
            disable_devicons = false,
          },
        },
      },
    },
  },
  overwrite = {},
}