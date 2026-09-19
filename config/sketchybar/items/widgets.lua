local colors = require("colors")
local settings = require("settings")

local date = sbar.add("item", "date", {
  position = "right",
  padding_left = 4,
  padding_right = 10,
  icon = {
    string = "󰃭",
    color = colors.clock,
    padding_right = 7,
  },
  label = {
    width = 68,
    align = "right",
  },
  background = { drawing = false },
  update_freq = 60,
  click_script = [[open -a Calendar]],
})

date:subscribe({ "routine", "forced", "system_woke" }, function()
  date:set({ label = { string = os.date("%m/%d (%a)") } })
end)

local clock = sbar.add("item", "clock", {
  position = "right",
  padding_left = 4,
  padding_right = 4,
  icon = {
    string = "󰥔",
    color = colors.clock,
    padding_right = 3,
  },
  label = {
    width = 44,
    align = "right",
  },
  background = { drawing = false },
  update_freq = 10,
  click_script = [[open -a Calendar]],
})

clock:subscribe({ "routine", "forced" }, function()
  clock:set({ label = { string = os.date("%H:%M") } })
end)

local battery = sbar.add("item", "battery", {
  position = "right",
  padding_left = 4,
  padding_right = 4,
  icon = {
    string = "󰁹",
    color = colors.battery,
  },
  label = {
    width = 38,
    align = "right",
  },
  background = { drawing = false },
  update_freq = 120,
})

local function update_battery()
  sbar.exec("/usr/bin/pmset -g batt", function(output)
    local percentage = tonumber(output:match("(%d+)%%"))
    if not percentage then
      return
    end

    battery:set({
      icon = {
        string = output:find("AC Power", 1, true) and "󰂄" or "󰁹",
        color = percentage <= 20 and colors.alert or colors.battery,
      },
      label = { string = percentage .. "%" },
    })
  end)
end

battery:subscribe({ "routine", "forced", "power_source_change", "system_woke" }, update_battery)

local cpu = sbar.add("item", "cpu", {
  position = "right",
  padding_left = 4,
  padding_right = 4,
  icon = {
    string = "",
    color = colors.cpu,
  },
  label = {
    width = 38,
    align = "right",
  },
  background = { drawing = false },
  update_freq = 5,
})

local function update_cpu()
  sbar.exec([[/usr/bin/top -l 1 -n 0 | /usr/bin/awk '/CPU usage/ { gsub("%", "", $7); print int(100 - $7 + 0.5) }']], function(output)
    local percentage = tonumber(output)
    if percentage then
      cpu:set({ label = { string = percentage .. "%" } })
    end
  end)
end

cpu:subscribe({ "routine", "forced", "system_woke" }, update_cpu)

local volume = sbar.add("item", "volume", {
  position = "right",
  padding_left = 10,
  padding_right = 4,
  icon = {
    string = "󰕾",
    color = colors.volume,
  },
  label = {
    width = 38,
    align = "right",
  },
  background = { drawing = false },
})

local function set_volume(value)
  local percentage = math.floor(tonumber(value) or 0)
  local muted = percentage == 0

  volume:set({
    icon = {
      string = muted and "󰖁" or "󰕾",
      color = muted and colors.muted or colors.volume,
    },
    label = { string = percentage .. "%" },
  })
end

volume:subscribe("volume_change", function(env)
  set_volume(env.INFO)
end)

volume:subscribe({ "forced", "system_woke" }, function()
  sbar.exec([[/usr/bin/osascript -e 'output volume of (get volume settings)']], set_volume)
end)

sbar.add("bracket", "status", { volume.name, cpu.name, battery.name, date.name, clock.name }, {
  background = {
    color = colors.surface_alt,
    height = settings.item_height,
    corner_radius = 11,
  },
})
