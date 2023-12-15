return {
  default = {
    opts = {
      snippet_engine = 'luasnip',
      mappings = {
        docs_down = '<C-b>',
        docs_up   = '<C-f>',
        complete  = '<C-space>',
        close     = '<C-e>',
      },
      -- 'tab' or 'enter'
      completion_style = 'tab',
      config = {
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = 0,
            side_padding = 1,
          },
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(_)
          end,
        },
        mapping = {},
        formatting = {},
        -- view = { entries = 'native' },
        experimental = {
          -- ghost_text = true,
        }
      },
    },
  },
}
