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
        normal = {
          -- tab switching
          ['<TAB>'] = { vim.cmd.tabnext, 'Next Tab' },
          ['<S-TAB>'] = { vim.cmd.tabprev, 'Prev Tab' },
          ['<space><TAB>'] = { ':$tabedit<CR>', 'Open New Tab' },
          -- quick fix list
          ['<c-n>'] = { ':cnext<cr>', 'goto next item in qf list' },
          ['<c-b>'] = { ':cprev<cr>', 'goto prev item in qf list' },
          -- copy/pasting from system clipboard
          ['<c-v>'] = { '"+p', 'paste from system clipboard' },
          -- < and > indents
          ['<'] = { '<gv', 'Decrease indention' },
          ['>'] = { '>gv', 'Increase indention' },
          [',tb'] = { function()
            ---@diagnostic disable
            _G.toggle_transparent_background()
          end, 'toggle transparent background' },
          ['<C-\\>'] = { ':vs<CR>:wincmd l<CR>', 'Split File Vertically' },
        },
        visual = {
          -- copy/pasting from system clipboard
          ['<c-c>'] = { '"+y', 'copy to system clipboard' },
        },
      },
    },
  },
}
