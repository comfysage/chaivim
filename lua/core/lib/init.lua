return {
  setup = function()
    core.lib = {}
    require 'core.plugin.icons'.setup()
    require 'core.plugin.hl'.setup()
    require 'core.plugin.keymaps'
  end,
}
