core.lib.color = {}

---@alias core.types.lib.color.Color { r: integer, g: integer, b: integer }

---@class CoreLib__color
---@field rgb fun(props: core.types.lib.color.Color): integer
function core.lib.color.rgb(props)
  if not props or not props.r or not props.g or not props.b then return 0 end
  return core.lib.math.components_to_hex { [1] = props.r, [2] = props.g, [3] = props.b }
end

---@class CoreLib__color
---@field mix fun(ratio, props): integer
---@param ratio number Ratio of color2 mixed into color1; 1.0 means only color2
---@param props { [1]: integer, [2]: integer }
function core.lib.color.mix(ratio, props)
  local color1 = core.lib.math.hex_to_rgb(props[1])
  local color2 = core.lib.math.hex_to_rgb(props[2])
  if not props or not props[1] or not props[2] then return 0 end

  local mix = { r = 0, g = 0, b = 0 }
  for slider, _ in pairs(mix) do
    mix[slider] = (1-ratio) * color1 + ratio * color2
  end

  return core.lib.math.components_to_hex(mix)
end
