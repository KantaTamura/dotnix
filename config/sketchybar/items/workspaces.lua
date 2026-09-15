local colors = require("colors")
local settings = require("settings")

local workspace_ids = {
  "1", "2", "3", "4", "5",
}

local dot_colors = {
  colors.accent,
  colors.cyan,
  colors.violet,
}

sbar.add("event", "aerospace_workspace_change")

local workspace_items = {}

for index, workspace_id in ipairs(workspace_ids) do
  local item_name = "workspace." .. workspace_id
  workspace_items[#workspace_items + 1] = item_name

  local workspace = sbar.add("item", item_name, {
    position = "left",
    width = 30,
    icon = {
      string = "●",
      color = dot_colors[((index - 1) % #dot_colors) + 1],
      width = 30,
      align = "center",
      padding_left = 0,
      padding_right = 0,
      font = {
        family = settings.font,
        style = "Semibold",
        size = settings.workspace_dot_size,
      },
    },
    label = { drawing = false },
    background = {
      drawing = false,
      height = 22,
      corner_radius = 9,
      color = colors.workspace_selected,
    },
    padding_left = 0,
    padding_right = 0,
    click_script = "/opt/homebrew/bin/aerospace workspace " .. workspace_id,
  })

  workspace:subscribe("aerospace_workspace_change", function(env)
    local focused = env.FOCUSED_WORKSPACE == workspace_id

    sbar.animate("tanh", 12, function()
      workspace:set({
        background = { drawing = focused },
      })
    end)
  end)
end

sbar.add("bracket", "workspaces", workspace_items, {
  background = {
    color = colors.workspace_surface,
    height = settings.item_height,
    corner_radius = 11,
  },
})

sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --focused", function(output)
  local focused_workspace = output:match("^%s*(.-)%s*$")
  sbar.trigger("aerospace_workspace_change", {
    FOCUSED_WORKSPACE = focused_workspace,
  })
end)
