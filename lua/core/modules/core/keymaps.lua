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
      -- default options used for keymaps
      defaults = {},
      mappings = {
        tabs = {
          -- tab switching
          { 'normal', '<tab>',        vim.cmd.tabnext, 'Next Tab' },
          { 'normal', '<S-TAB>',      vim.cmd.tabprev, 'Prev Tab' },
          { 'normal', '<space><TAB>', ':$tabedit<CR>', 'Open New Tab' },
        },
        windows = {
          { 'normal', '<C-\\>', ':vs<CR>:wincmd l<CR>', 'Split File Vertically' },
        },
        qf_list = {
          -- quick fix list
          { 'normal', '<c-n>', ':cnext<cr>', 'goto next item in qf list' },
          { 'normal', '<c-b>', ':cprev<cr>', 'goto prev item in qf list' },
        },
        indent = {
          -- < and > indents
          { 'normal', '<', '<gv', 'Decrease indention' },
          { 'normal', '>', '>gv', 'Increase indention' },
        },
        toggle_ui = {
          { 'normal', ',tb', function()
            ---@diagnostic disable
            _G.toggle_transparent_background()
          end, 'toggle transparent background' },
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
