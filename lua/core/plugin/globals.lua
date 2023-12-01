Spec = Spec or {}

---@param props LazyPluginSpec
---@return LazyPluginSpec
function Spec.colorscheme(props)
  ---@type LazyPluginSpec
  local _opts = {
    priority = 1200,
    lazy = true,
  }
  return vim.tbl_deep_extend("force", _opts, props)
end
