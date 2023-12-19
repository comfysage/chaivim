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
      buttons = function()
        local buttons = {
          core.modules.core.telescope.opts.mappings.find_files,
          core.modules.core.telescope.opts.mappings.colorscheme,
        }

        local result = {}

        for i, lhs in ipairs(buttons) do
          local map = require 'keymaps.data'.get_mapping({ lhs = lhs }) or { desc = '', lhs = '', fn = '' }
          result[i] = { map.desc, map.lhs, map.fn }
        end

        local map = require 'keymaps.data'.get_mapping({ desc = 'show cheatsheet' }) or { desc = '', lhs = '', fn = '' }
        result[#result + 1] = { map.desc, map.lhs, map.fn }
        return result
      end,
    },
  },
}
