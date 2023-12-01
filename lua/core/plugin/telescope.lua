-- Custom Functions

local builtin = require 'telescope.builtin'

local themes = require 'telescope.themes'

local previewers = require 'telescope.previewers'
local pickers = require 'telescope.pickers'
local sorters = require 'telescope.sorters'
local finders = require 'telescope.finders'

local M = {}

-- Dropdown Theme

M.dropdown = require 'telescope.themes'.get_dropdown({
    borderchars = {
      --[[ { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'}, ]]
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      prompt = {"─", "│", " ", "│", '╭', '╮', "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    },
    width = 0.8,
    previewer = false,
    prompt_title = false
  })

-- Ivy Theme

M.IvyTheme = themes.get_ivy {
    -- border = true,
    preview = true,
    shorten_path = true,
    hidden = true,
    prompt_title = '',
    preview_title = '',
    borderchars = {
      -- preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      preview = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' };
    },
  }

-- Space Station Theme

M.StationTheme = {
    -- winblend = 20;
    width = 0.8;
    show_line = false;
    results_title = '';
    prompt_prefix = '$ ';
    prompt_position = 'top';
    prompt_title = '';
    preview_title = '';
    preview_width = 0.4;
    borderchars = {
      --[[ { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {" ", "│", "─", "│", '│', '│', "┘", "└"},
      results = {"─", "│", " ", "│", "┌", "┐", "│", "│"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'}, ]]
    -- '<,'>s/└/╰/g | '<,'>s/┘/╯/g | '<,'>s/┐/╮/g | '<,'>s/┌/╭/g
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      prompt = {" ", "│", "─", "│", '│', '│', "╯", "╰"},
      results = {"─", "│", " ", "│", "╭", "╮", "│", "│"},
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    },
  }

-- Space Station

function M.space(props)
  props = props or {}
  local opts = MergeTable(M.StationTheme, {
    -- border = true,
    -- previewer = false,
    shorten_path = true,
    hidden = true,
  })

  -- builtin.git_files(MergeTable(opts,props))
  builtin.find_files(MergeTable(opts,props))
end

function M.grep(props)
  props = props or {}
  local opts = MergeTable(M.StationTheme, {
    max_results = 20
  })

  builtin.live_grep(MergeTable(opts, props))
end

-- Explorer

function M.explorer(props)
  props = props or {}
  local opts = M.IvyTheme
  opts = MergeTable(M.dropdown, {
    preview = true,
    shorten_path = true,
    hidden = true,
    prompt_title = '',
    preview_title = '',
  })

  builtin.find_files(MergeTable(opts, props))
end

-- Ivy Git Finder

function M.git_files(props)
  props = props or {}
  local opts = M.IvyTheme

  builtin.git_files(MergeTable(opts, props))
end

-- Dotfile Finder
function M.edit_dotfiles()
  M.explorer({
    -- cwd = '~/.config/nvim',
    cwd = '/mnt/d/home/kitchen/config/nvim',
  })
end

-- Edit Markdown Notes

function M.edit_notes()
  M.explorer({
    cwd = '/mnt/d/home/kitchen/Dropbox/notes/',
  })
end

--

function M.symbols(props)
  local opts = MergeTable(M.StationTheme, {
    -- border = true,
    -- previewer = false,
    shorten_path = true,
    hidden = true,
  })

  -- builtin.git_files(MergeTable(opts,props))
  builtin.lsp_document_symbols(MergeTable(opts,props))
end

-- 

function M.grep_current_file (props)
  local opts = MergeTable(M.StationTheme, { })

  R ('telescope.builtin').current_buffer_fuzzy_find(MergeTable(opts, props))
end

pickers.new {
  results_title = "Resources",
  -- Run an external command and show the results in the finder window
  -- finder = finders.new_oneshot_job({"git","help", "|", "grep","-oE","'^ +\\w+'"}),
  finder = finders.new_oneshot_job({"git","help","|", "echo", "h"}),
  sorter = sorters.get_fuzzy_file(),
  previewer = previewers.new_buffer_previewer {
    define_preview = function(self, entry, status)
       -- Execute another command using the highlighted entry
      return require('telescope.previewers.utils').job_maker(
          {"git", "help", entry.value},
          self.state.bufnr,
          {
            callback = function(bufnr, content)
              if content ~= nil then
                -- require('telescope.previewers.utils').regex_highlighter(bufnr, 'git ')
              end
            end,
          })
    end
  },
}--[[ :find() ]]

-- Helpers

function MergeTable(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                MergeTable(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

return M

