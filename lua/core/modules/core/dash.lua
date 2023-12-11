return {
  default = {
    opts = {
      open_on_startup = true,
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
        { 'find files',   '', function() require 'core.plugin.telescope'.picker.find_files {} end },
        { 'select theme', '', function() require 'telescope.builtin'.colorscheme() end },
      },
    },
  },
}
