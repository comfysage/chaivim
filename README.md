# sentinel

## installation

```lua
-- init.lua
local rootpath = vim.fn.stdpath("data") .. "/core"
local sentinelpath = rootpath .. "/sentinel"
vim.opt.rtp:prepend(sentinelpath)

local ok, core = pcall(require, 'core')
if not ok then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/crispybaccoon/sentinel.nvim.git",
    sentinelpath,
  })
end
```

## usage

```lua
-- init.lua
require 'core'.setup {
    colorscheme = 'nord',
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
        },
    }
}
```

all config fields can be overwritten after `setup()`:
```lua
core.config.colorscheme = 'tokyonight'
```
