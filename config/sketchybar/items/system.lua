sbar.add("item", "system", {
  position = "left",
  icon = { string = "⌘" },
  label = { drawing = false },
  padding_left = 2,
  padding_right = 5,
  click_script = [[open -a "System Settings"]],
})
