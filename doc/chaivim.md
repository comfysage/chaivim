# installation

```lua
-- init.lua
local rootpath = vim.fn.stdpath("data") .. "/core"
local chaipath = rootpath .. "/chai"

if not vim.loop.fs_stat(chaipath) then
  vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/comfysage/chaivim.git",
    chaipath,
  }):wait()
end

vim.opt.rtp:prepend(chaipath)
```

chai can be updated with:
```lua
require 'core'.update()
```

# usage

```lua
require 'core'.setup {
    colorscheme = 'aurora',
    transparent_background = true,
    transparent_fn = {
        evergarden = function(t)
            _G.evergarden_config.transparent_background = t
        end,
        aurora = function(t)
            _G.aurora_config.transparent_background = t
        end,
        aki = function(t)
            _G.aki_config.transparent_background = t
        end,
        adachi = function(t)
            _G.adachi_config.transparent_background = t
        end,
        gruvboxed = function(t)
            _G.gruvboxed_config.transparent_background = t
        end,
    },
    config_module = 'custom', -- defaults to 'custom'
    modules = {
        ['core'] = {
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
            },
            {
                'highlights',
                event = 'UIEnter',
                opts = {
                    fix = function()
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
            },
            {
                'dash',
                opts = {
                    open_on_startup = true, -- defaults to `false`
                },
            },
        },
        ['custom'] = {
            -- your custom modules (in `lua/custom/`)
        },
    },
}
```

# configuration

core-config
: core configuration

core-config-log_level
: Minimum log level

Set to `vim.log.levels.OFF` to disable logging from `chai`, or `vim.log.levels.TRACE`
to enable all logging.

Type: `vim.log.levels` (default: `vim.log.levels.INFO`)

module-spec
: specification for a module

modules.highlights.fix
: specification for core highlight module

Type: `function` (default: `nil`)
