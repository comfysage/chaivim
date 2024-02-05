return {
  colorscheme = 'evergarden',
  transparent_background = false,
  modules = {
    core = {
      {
        'options',
        opts = {
          cursorline = false,
          tab_width = 2,
          scrolloff = 5,
        },
      },
      {
        'ui',
        opts = {
          general = {
            separator_style = 'round',
          },
          cursor = {
            enabled = false,
          },
          statusline = {
            enabled = true,
          },
          bufferline = {
            enabled = true,
          },
        }
      },
      {
        'dash',
        opts = {
          open_on_startup = true,
        },
      },
    },
    custom = {
      -- your custom modules (in `lua/custom/`)
      -- {
      --   'example',
      --   opts = {
      --     msg = 'hello from `lua/custom/example`',
      --   },
      -- },
    },
  }
}
