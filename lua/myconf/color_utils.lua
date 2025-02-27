-- color_utils.lua

-- Function to convert hex color to RGB
local function hex_to_rgb(hex)
   hex = hex:gsub("#", "")
   return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

-- Function to convert RGB to hex color
local function rgb_to_hex(r, g, b)
   return string.format("#%02x%02x%02x", r, g, b)
end

-- Function to adjust brightness of a hex color
local function adjust_brightness(hex, factor)
   local r, g, b = hex_to_rgb(hex)
   r = math.min(255, math.max(0, r * factor))
   g = math.min(255, math.max(0, g * factor))
   b = math.min(255, math.max(0, b * factor))
   return rgb_to_hex(r, g, b)
end

-- Function to calculate the brightness factor
local function calculate_brightness_factor(original_hex, target_hex)
   local r1, g1, b1 = hex_to_rgb(original_hex)
   local r2, g2, b2 = hex_to_rgb(target_hex)

   local factor_r = r2 / r1
   local factor_g = r2 / g1
   local factor_b = r2 / b1

   -- Average the factors to get a single brightness factor
   local factor = (factor_r + factor_g + factor_b) / 3
   return factor
end

return {
   hex_to_rgb = hex_to_rgb,
   rgb_to_hex = rgb_to_hex,
   adjust_brightness = adjust_brightness,
   calculate_brightness_factor = calculate_brightness_factor,
}
