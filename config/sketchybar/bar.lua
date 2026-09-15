local colors = require("colors")
local settings = require("settings")

sbar.bar({
  position = "top",
  topmost = "window",
  height = settings.height,
  margin = 8,
  y_offset = 6,
  corner_radius = settings.corner_radius,
  color = colors.bar,
  border_width = 0,
  border_color = colors.border,
  blur_radius = 28,
  padding_left = 6,
  padding_right = 6,
  font_smoothing = true,
  shadow = false,
})
