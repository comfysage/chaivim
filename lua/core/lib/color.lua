core.lib.color = {}

---@alias core.types.lib.color.Color__rgb { r: integer, g: integer, b: integer }
---@alias core.types.lib.color.Color core.types.lib.color.Color__rgb
---@alias core.types.lib.color.Color__hsl { hue: integer, sat: integer, lum: integer }

---@class CoreLib__color
---@field rgb fun(props: core.types.lib.color.Color__rgb): integer
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
    mix[slider] = math.floor((1-ratio) * color1[slider] + ratio * color2[slider])
  end

  return core.lib.color.rgb(mix)
end

---@class CoreLib__color
---@field rgb_to_hsl fun(props: core.types.lib.color.Color__rgb): core.types.lib.color.Color__hsl
function core.lib.color.rgb_to_hsl(props)
  local hsl = { hue = 0, sat = 0, lum = 0 }
  -- make r, g, and b fractions of 1
  local r = props.r / 255;
  local g = props.g / 255;
  local b = props.b / 255;

  -- find greatest and smallest channel values
  local cmin = math.min(r, g, b)
  local cmax = math.max(r, g, b)
  local delta = cmax - cmin
  local h = 0
  local s = 0
  local l = 0

  -- calculate hue
  -- no difference
  if (delta == 0) then
    h = 0
    -- red is max
  elseif (cmax == r) then
    h = ((g - b) / delta) % 6
    -- green is max
  elseif (cmax == g) then
    h = (b - r) / delta + 2
    -- blue is max
  else
    h = (r - g) / delta + 4
  end

  h = math.floor(h * 60);

  -- make negative hues positive behind 360°
  if (h < 0) then
    h = h + 360
  end

  -- calculate lightness
  l = (cmax + cmin) / 2

  -- calculate saturation
  s = delta == 0 and 0 or delta / (1 - math.abs(2 * l - 1))

  hsl = {
    hue = h, -- as x
    sat = s, -- as 0.x
    lum = l, -- as 0.x
  }

  return hsl
end

---@class CoreLib__color
---@field hsl_to_rgb fun(props: core.types.lib.color.Color__hsl): core.types.lib.color.Color__rgb
function core.lib.color.hsl_to_rgb(props)
  local color = { r = 0, g = 0, b = 0 }

  -- all as fractions
  local h = props.hue / 360
  local s = props.sat
  local l = props.lum
  local r = 0
  local g = 0
  local b = 0

  if s == 0 then
    -- achromatic
    r = l
    g = l
    b = l
  else
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = core.lib.color.hue_to_rgb(p, q, h + 1 / 3)
    g = core.lib.color.hue_to_rgb(p, q, h)
    b = core.lib.color.hue_to_rgb(p, q, h - 1 / 3)
  end

  color = {
    r = math.ceil(r * 255),
    g = math.ceil(g * 255),
    b = math.ceil(b * 255),
  }
  return color
end

---@class CoreLib__color
---@field hue_to_rgb fun(p, q, t): number
function core.lib.color.hue_to_rgb(p, q, t)
  if t < 0 then t = t + 1 end
  if t > 1 then t = t - 1 end
  if (t < 1 / 6) then
    return p + (q - p) * 6 * t
  end
  if (t < 1 / 2) then
    return q
  end
  if (t < 2 / 3) then
    return p + (q - p) * (2 / 3 - t) * 6
  end
  return p
end
