return {
  default = {
    --- default mappings can be disabled with:
    --- ```lua
    --- opts = {
    ---   mappings = {
    ---     normal = {},
    ---     visual = {},
    ---     insert = {},
    ---   },
    --- },
    --- ```
    opts = {
      leader = 'SPC',
      localleader = nil,
      -- default options used for keymaps
      defaults = {},
      -- special keys are imported from ui->general->key_labels
      special_keys = nil,
      mappings = {
        tabs = {
          -- tab switching
          { 'normal', '<space><tab>]', vim.cmd.tabnext, 'next tab' },
          { 'normal', '<space><tab>[', vim.cmd.tabprev, 'prev tab' },
          { 'normal', '<space><tab>n', ':$tabedit<CR>', 'open new tab' },
          { 'normal', '<space><tab>d', ':tabclose<CR>', 'close current tab' },
          { 'normal', '<space><tab>x', ':tabclose<CR>', 'close current tab' },
        },
        windows = {
          {
            'normal',
            '<C-\\>',
            ':vs<CR>:wincmd l<CR>',
            'split file vertically',
          },
        },
        buffers = {
          { 'normal', '<leader>x', ':Close<cr>', 'close buffer' },
        },
        qf_list = {
          -- quick fix list
          { 'normal', '<c-n>', ':cnext<cr>', 'goto next item in qf list' },
          { 'normal', '<c-b>', ':cprev<cr>', 'goto prev item in qf list' },
        },
        indent = {
          -- < and > indents
          { 'visual', '<', '<gv', 'decrease indention' },
          { 'visual', '>', '>gv', 'increase indention' },
        },
        toggle_ui = {
          {
            'normal',
            ',tb',
            function()
              ---@diagnostic disable
              _G.toggle_transparent_background()
            end,
            'toggle transparent background',
          },
        },
        show_ui = {
          {
            'normal',
            '<leader>sc',
            function()
              require('core.ui.cheatsheet').open()
            end,
            'show cheatsheet',
          },
          {
            'normal',
            '<leader>sh',
            function()
              require('core.ui.status'):open()
            end,
            'show core status',
          },
        },
        copy_paste = {
          -- copy/pasting from system clipboard
          { 'normal', '<c-v>', '"+p', 'paste from system clipboard' },
          { 'visual', '<c-c>', '"+y', 'copy to system clipboard' },
        },
      },
    },
  },
}
