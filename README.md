# chaivim

:tea: easily configurable neovim system with solid defaults and a cozy editor experience.

![dash](images/dash.png)

![telescope__config](images/telescope__config.png)

## :sparkles: Features

### Lazy plugin management

chaivim uses [lazy.nvim](https://github.com/folke/lazy.nvim) to manage plugins.

### integrated plugins

- :telescope: [telescope](https://github.com/nvim-telescope/telescope.nvim) - a highly extendable fuzzy finder.
- :evergreen_tree: [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - treesitter configurations and abstraction layer for neovim.
- :computer: [keymaps](https://github.com/comfysage/keymaps.nvim) - a keymap manager for neovim.
- :airplane: [lualine](https://github.com/nvim-lualine/lualine.nvim) - a blazing fast and easy to configure neovim statusline plugin.
- :pencil: [cmp](https://github.com/hrsh7th/nvim-cmp) - a completion plugin for neovim.
- :scissors: [luasnip](https://github.com/L3MON4D3/LuaSnip) with [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - a snippet engine for neovim.
- :hammer: [mini.nvim](https://github.com/echasnovski/mini.nvim) - the "swiss army knife" among neovim plugins.
- :vertical_traffic_light: [gitsigns](https://github.com/lewis6991/gitsigns.nvim) - git integration for neovim.
- :scroll: [which-key](https://github.com/folke/which-key.nvim) - a keymap ui for neovim.
- :pushpin: [todo-comments](https://github.com/folke/todo-comments.nvim) - highlight, list and search todo comments in your projects.
- :construction: [trouble](https://github.com/folke/trouble.nvim) - a diagnostics manager.
- :balloon: [incline](https://github.com/b0o/incline.nvim) - floating statuslines for neovim.

## :lock: requirements

- Neovim `>= 0.9.0` (needs to be built with LuaJIT)
- git `>= 2.19.0` (for partial clones support)
- a Nerd Font (optional)

## :package: installation

chaivim can be installed [manually](#manual-install) or through the installer:
```shell
curl -fsSL https://github.com/comfysage/chaivim/raw/mega/utils/installer/install.sh | sh
```

### manual install

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

## :rocket: usage

```lua
-- init.lua
require 'core'.setup('custom.config', 'custom.modules')

-- lua/custom/config.lua
return {
    ui = {
        colorscheme = 'evergarden',
        transparent_background = false,
    },
}

-- lua/custom/modules.lua
return {
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
```
or call `require 'core'.setup 'custom'` to load a custom configuration from `lua/custom/init.lua`:
```lua
-- init.lua
require 'core'.setup 'custom'

-- lua/custom/init.lua
return {
    ui = {
        colorscheme = 'evergarden',
    },
    modules = {
        core = {
            { 'options' },
            { 'base' },
        },
    },
}
```

all config fields can be overwritten after `setup()`:
```lua
core.config.ui.colorscheme = 'tokyonight'
```

## :gear: config modules

view example configurations for modules [here](doc/modules.md).

## :camera: screenshots

![nix-config](images/nix-config.png)
