### `base` module
```lua
{
  'base',
  event = nil,
  opts = {
    -- `file_associations` can be used to set options for specific filetypes or
    --  setup a custom environment when opening a specific file
    file_associations = {
      { { '*.vim', '*.md' }, 'Remove line numbers', function()
        vim.opt_local.number = false
      end },
      { { '*.vto', '*.njk' }, '[Template Engine] set filetype html', function()
        vim.bo.filetype = 'html'
      end },
      { { '*' }, 'Use `q` to quit qf list', function(opts)
        if vim.bo[opts.buf].filetype == 'qf' then
          vim.keymap.set('n', 'q', ':quit<cr>', { buffer = opts.buf })
        end
      end },
    },
  }
}
```
### `base16` module
```lua
{
  'base16',
  event = 'UIEnter',
  opts = {
    -- you can try out different colorschemes with `require 'core.plugin.base16'.select()`
    colorscheme = 'nord',
  },
}
```
### `cmp` module
```lua
{ "cmp",
  opts = {
    completion_style = "tab",
    config = {
      experimental = {},
      formatting = {},
      mapping = {},
      snippet = {
        expand = <function 1>
      },
      window = {
        completion = {
          col_offset = 0,
          side_padding = 1,
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None"
        }
      }
    },
    mappings = {
      close = "<C-e>",
      complete = "<C-space>",
      docs_down = "<C-b>",
      docs_up = "<C-f>"
    },
    snippet_engine = "luasnip"
  }
}
```
### `dash` module
```lua
{
  'dash',
  opts = {
    -- when set to true, the dashboard will open on startup when the current buffer is empty
    open_on_startup = true,
    -- use custom ascii art
    header = {
      [[      )  (      ]],
      [[     (   ) )    ]],
      [[      ) ( (     ]],
      [[           )    ]],
      [[   ▟██████████▙ ]],
      [[ █▛██▛ ▟▛ ▟▛ ▟█ ]],
      [[ ▜▙█▛ ▟▛ ▟▛ ▟██ ]],
      [[   ▝██████████▛ ]],
      [[    ▝▀▀▀▀▀▀▀▀▀  ]],
    },
    buttons = {
      { 'find files', 'SPC SPC', function() require 'core.plugin.telescope'.picker.find_files {} end },
    },
  },
}
```
### `highlights` module
```lua
{
  'highlights',
  event = 'UIEnter',
  opts = {
    -- `fix()` is run every time the colorscheme is changed
    -- it can be used to override some hightlights or create custom hightlights
    fix = function()
      vim.cmd [[ hi clear SpellCap ]]

      if vim.g.neovide then
        local alpha = function()
          return string.format("%x", math.floor(255 * vim.g.transparency or 0.0))
        end
        local bg_color = '#' .. vim.api.nvim_get_hl(0, { name = 'Normal' }).bg

        vim.g.neovide_background_color = bg_color .. alpha()
      end

      -- notes

      local groups = {
        fixme   = { "Fixme", vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }) },
        todo    = { "Todo", vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }) },
        note    = { "Note", vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }) },
        success = { "Success", vim.api.nvim_get_hl(0, { name = "DiagnosticOk" }) },
        failure = { "Failure", vim.api.nvim_get_hl(0, { name = "DiagnosticError" }) },
      }
      for _, v in pairs(groups) do
        vim.api.nvim_set_hl(0, v[1], { fg = v[2].fg })
        vim.api.nvim_set_hl(0, v[1] .. 'Note', { fg = v[2].fg, reverse = true })
      end
    end
  },
}
```
### `keymaps` module
```lua
{ "keymaps",
  opts = {
    defaults = {},
    leader = "SPC",
    mappings = {
      buffers = { { "normal", "<leader>x", ":Close<cr>", "close buffer" } },
      copy_paste = { { "normal", "<c-v>", '"+p', "paste from system clipboard" }, { "visual", "<c-c>", '"+y', "copy to system clipboard" } },
      indent = { { "visual", "<", "<gv", "decrease indention" }, { "visual", ">", ">gv", "increase indention" } },
      qf_list = { { "normal", "<c-n>", ":cnext<cr>", "goto next item in qf list" }, { "normal", "<c-b>", ":cprev<cr>", "goto prev item in qf list" } },
      show_ui = { { "normal", "<leader>sc", <function 1>, "show cheatsheet" } },
      tabs = { { "normal", "<tab>", <function 2>, "next tab" }, { "normal", "<S-TAB>", <function 3>, "prev tab" }, { "normal", "<space><TAB>", ":$tabedit<CR>", "open new tab" } },
      toggle_ui = { { "normal", ",tb", <function 4>, "toggle transparent background" } },
      windows = { { "normal", "<C-\\>", ":vs<CR>:wincmd l<CR>", "split file vertically" } }
    },
    special_keys = {
      BS = "<bs>",
      SPC = "<space>",
      STAB = "<s-tab>",
      TAB = "<tab>"
    }
  }
}
```
### `lazy` module
```lua
{ "lazy",
  opts = {
    config = {},
    module = "plugins"
  }
}
```
### `lsp` module
```lua
{ "lsp",
  opts = {
    config = {
      severity_sort = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      virtual_text = {
        prefix = <function 1>,
        source = false,
        spacing = 4
      }
    },
    mappings = {
      format = ",f",
      goto_declaration = "gD",
      goto_definition = "gd",
      goto_implementation = "gi",
      goto_next = "<M-l>",
      goto_prev = "<M-h>",
      goto_references = "gR",
      hover = "K",
      open_float = "<space>l",
      peek_definition = "<space>gd",
      rename = "gr",
      set_qflist = "<space>q",
      show_code_action = "gl",
      show_lsp_info = "<space>si",
      show_signature = "<C-k>",
      show_type_definition = "gT"
    },
    servers = {}
  }
}
```
### `mini` module
```lua
{ "mini",
  opts = {
    plugins = {
      align = {
        opts = {}
      },
      comment = {
        config = <function 1>,
        opts = {
          mappings = {
            comment = "gc",
            comment_line = "gcc",
            comment_visual = "gc",
            textobject = "gc"
          },
          options = {
            ignore_blank_line = false,
            pad_comment_parts = true,
            start_of_line = false
          }
        }
      },
      files = {
        config = <function 2>,
        opts = {
          options = {
            use_as_default_explorer = false
          },
          windows = {
            max_number = inf,
            preview = false,
            width_focus = 50,
            width_nofocus = 15,
            width_preview = 25
          }
        }
      },
      move = {
        opts = {
          mappings = {
            down = "<M-j>",
            left = "<M-h>",
            line_down = "<M-j>",
            line_left = "",
            line_right = "",
            line_up = "<M-k>",
            right = "<M-l>",
            up = "<M-k>"
          },
          options = {
            reindent_linewise = true
          }
        }
      },
      pairs = {
        opts = {}
      },
      surround = {
        opts = {
          highlight_duration = 300,
          mappings = {
            add = "S",
            delete = "ds",
            find = "sf",
            find_left = "sF",
            highlight = "",
            replace = "cs",
            suffix_last = "",
            suffix_next = "",
            update_n_lines = ""
          },
          n_lines = 20,
          respect_selection_type = false,
          search_method = "cover",
          silent = false
        }
      },
      trailspace = {
        opts = {}
      }
    }
  }
}
```
### `options` module
```lua
{
  'options',
  event = nil,
  opts = {
    cursorline = false,
    tab_width = 2,
    scrolloff = 5,
    use_ripgrep = true,
    treesitter_folds = false,
  }
}
```
### `telescope` module
```lua
{
  'telescope',
  event = 'UIEnter',
  opts = {
    use_fzf = true,
    config = {}, -- `config` will be passed to `telescope.setup()`
  },
}
```
### `treesitter` module
```lua
{ "treesitter",
  opts = {
    config = {
      auto_install = false,
      ensure_installed = {},
      highlight = {
        additional_vim_regex_highlighting = false,
        disable = {},
        enable = true
      },
      ignore_install = {},
      indent = {
        enable = true
      },
      sync_install = false,
      textobjects = {}
    },
    ensure_installed = {}
  }
}
```
