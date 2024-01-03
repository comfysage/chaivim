core.lib.math = {}

---@class CoreLib__math
---@field components_to_hex fun(props: Array<integer>): integer
function core.lib.math.components_to_hex(props)
  local n = 0
  for i, v in ipairs(props) do
    local m = #props - i
    n = n + ((256 ^ m) * v)
  end
  return n
end

---@class CoreLib__math
---@field hex_to_components fun(n: integer, v: integer): Array<integer>
function core.lib.math.hex_to_components(n, v)
  local _components = {}
  local components = {}
  local _n = v

  for i = 1, n, 1 do
    _components[i] = (256 ^ (n - i))
    components[i] = math.floor(_n / _components[i])
    components[i] = components[i] > 0 and components[i] or 0
    _n = _n - components[i] * _components[i]
  end

  return components
end

---@class CoreLib__math
---@field hex_to_rgb fun(n: integer): core.types.lib.color.Color
function core.lib.math.hex_to_rgb(n)
  local color = { r = 0, g = 0, b = 0 }
  local _n = n

  local r_component = (256 ^ 2)
  color.r = math.floor(_n / r_component)
  color.r = color.r > 0 and color.r or 0
  _n = _n - color.r * r_component

  local g_component = (256 ^ 1)
  color.g = math.floor(_n / g_component)
  color.g = color.g > 0 and color.g or 0
  _n = _n - color.g * g_component

  local b_component = (256 ^ 0)
  color.b = math.floor(_n / b_component)
  color.b = color.b > 0 and color.b or 0

  return color
end

---@class CoreLib__math
---@field avg fun(props: table<integer>): integer
function core.lib.math.avg(props)
  local sum = 0
  for _, v in ipairs(props) do
    sum = sum + v
  end
  return sum / #props
end
