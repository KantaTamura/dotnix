local fonts  = require("fonts")
local keys   = require("keys")
local tabs   = require("tabs")
local shell  = require("shell")
local doms   = require("domains")

local config = {
	enable_wayland = true,
    color_scheme = "iceberg-dark",
    warn_about_missing_glyphs = true,
    -- show_update_window = false,
    check_for_updates = false,
    enable_scroll_bar = false,
    window_background_opacity = 1.0,
    window_close_confirmation = "NeverPrompt",
    audible_bell = "Disabled",
    window_padding = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4,
    },
    window_frame = {
        border_left_width    = "0.4cell",
        border_right_width   = "0.4cell",
        border_bottom_height = "0.4cell",
        border_top_height    = "0.4cell",
        border_left_color    = "#161821",
        border_right_color   = "#161821",
        border_bottom_color  = "#161821",
        border_top_color     = "#161821",
    },
    inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.8,
    },
    hyperlink_rules = {
        {
            regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
            format = "$0",
        },
        {
            regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
            format = "$0",
        },
        {
            regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
            format = "mailto:$0",
        },
        {
            regex = [[\bfile://\S*\b]],
            format = "$0",
        },
        {
            regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
            format = "$0",
        },
        {
            regex = [[\b[tT](\d+)\b]],
            format = "https://example.com/tasks/?t=$1",
        },
    },
}

fonts.setup(config)
keys.setup(config)
tabs.setup(config)
shell.setup(config)
doms.setup(config)

return config
