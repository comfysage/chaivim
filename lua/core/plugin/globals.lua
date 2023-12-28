Spec = Spec or {}

Spec.defaults = {
  lazy = true,
  priority = 500,
}

setmetatable(Spec, {
  __call = function (t, props)
    if type(props) ~= 'table' then return end
    local spec = props
    for k, v in pairs(t.defaults) do
      spec[k] = v
    end
    return spec
  end
})

--- adds priority and lazy fields to plugin spec
--- example:
--- ```lua
--- return Spec.colorscheme {
---   'crispybaccoon/evergarden',
---   opts = {},
--- }
--- ```
--- is the same as:
--- ```lua
--- return {
---   'crispybaccoon/evergarden',
---   priority = 1200,
---   lazy = true,
---   opts = {},
--- }
--- ```
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
