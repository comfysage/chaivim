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
        { 'find files', core.modules.core.telescope.opts.mappings.find_files, function()
          require 'core.plugin.telescope'
              .picker.find_files {}
        end },
        { 'select theme', core.modules.core.telescope.opts.mappings.colorscheme, function()
          require 'telescope.builtin'
              .colorscheme()
        end },
      },
    },
  },
}
