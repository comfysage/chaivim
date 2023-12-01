return {
  load = function(props)
    local fn = {
      keymaps = function()
        local keymapspath = core.path.keymaps

        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/crispybaccoon/keymaps.nvim.git",
          keymapspath,
        })

        local ok, keymaps_nvim = pcall(R, 'keymaps')
        if not ok then
          return false
        end
        return keymaps_nvim
      end
    }
    fn[props]()
  end
}
