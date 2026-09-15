local colors = require("colors")
local settings = require("settings")

sbar.default({
  icon = {
    font = {
      family = settings.icon_font,
      style = "Medium",
      size = settings.icon_font_size,
    },
    color = colors.text,
    padding_left = 7,
    padding_right = 4,
  },
  label = {
    font = {
      family = settings.font,
      style = "Medium",
      size = settings.font_size,
    },
    color = colors.text,
    padding_left = 4,
    padding_right = 7,
    y_offset = -2,
  },
  background = {
    height = settings.item_height,
    corner_radius = settings.item_corner_radius,
    color = colors.surface,
  },
})
