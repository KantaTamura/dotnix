local colors = require("colors")

local front_app = sbar.add("item", "front_app", {
  position = "left",
  icon = {
    string = "·",
    color = colors.muted,
  },
  label = {
    color = colors.muted,
    max_chars = 28,
  },
  background = { drawing = false },
})

local function set_front_app(name)
  front_app:set({
    label = { string = name:match("^%s*(.-)%s*$") },
  })
end

front_app:subscribe("front_app_switched", function(env)
  set_front_app(env.INFO)
end)

front_app:subscribe("forced", function()
  sbar.exec([[/usr/bin/osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true']], set_front_app)
end)
