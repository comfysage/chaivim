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
        'dash',
        opts = {
          open_on_startup = true,
        },
      },
    },
    custom = {
      -- your custom modules (in `lua/custom/`)
      {
        'example',
        opts = {
          msg = 'hello from `lua/custom/example`',
        },
      },
    },
  }
}
