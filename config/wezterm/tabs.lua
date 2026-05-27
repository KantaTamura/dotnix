local wezterm = require("wezterm")
local mux     = wezterm.mux

local Tabs = {}
local Right = {}

-- wezterm format items
-- ref. https://wezfurlong.org/wezterm/config/lua/wezterm/format.html
Right.cells = {}

Right.colors = {
    background = "#1e2132",
    time_bg = "#2e3244",
    time_fg = "#c6c8d1",
    battery_bg = "#454b68",
    battery_fg = "#c6c8d1"
}

-- push text and attribute to right status
function Right.push(text, bc, fg, bg)
    table.insert(Right.cells, { Foreground = { Color = bg } })
    table.insert(Right.cells, { Background = { Color = bc } })
    table.insert(Right.cells, { Text = "" })
    table.insert(Right.cells, { Foreground = { Color = fg } })
    table.insert(Right.cells, { Background = { Color = bg } })
    table.insert(Right.cells, { Attribute = { Intensity = "Bold" } })
    table.insert(Right.cells, { Text = " " .. text .. " " })
    table.insert(Right.cells, "ResetAttributes")
end

-- set date
-- ref. https://wezfurlong.org/wezterm/config/lua/wezterm/strftime.html
function Right.set_date()
    local date = wezterm.strftime("%a %b %-d %H:%M")
    Right.push(date, Right.colors.background, Right.colors.time_fg, Right.colors.time_bg)
end

-- set battery status
-- ref. https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html
function Right.set_battery()
    local discharging_icons = { "󰂃", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹" }
    local charging_icons    = { "󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅" }

    local charge  = "?"
    local icon    = "󰂑"
    local is_note = false

    local function battery_stage(battery)
        if battery >= 1.0 then
            return 10
        elseif battery >= 0.9 then
            return 9
        elseif battery >= 0.8 then
            return 8
        elseif battery >= 0.7 then
            return 7
        elseif battery >= 0.6 then
            return 6
        elseif battery >= 0.5 then
            return 5
        elseif battery >= 0.4 then
            return 4
        elseif battery >= 0.3 then
            return 3
        elseif battery >= 0.2 then
            return 2
        elseif battery >= 0.1 then
            return 1
        else
            return 0
        end
    end

    for _, b in ipairs(wezterm.battery_info()) do
        if b.state ~= "Unknown" then
            is_note = true
        end

        local idx = battery_stage(b.state_of_charge)
        charge = string.format("%.0f%%", b.state_of_charge * 100)

        if b.state == "Charging" then
            icon = charging_icons[idx]
        else
            icon = discharging_icons[idx]
        end
    end

    if is_note then
        Right.push(icon .. charge, Right.colors.time_bg, Right.colors.battery_fg, Right.colors.battery_bg)
    end
end

function Tabs.setup(config)
    config.tab_bar_at_bottom = false
    config.show_new_tab_button_in_tab_bar = false
    config.tab_max_width = 50
    config.hide_tab_bar_if_only_one_tab = false
    config.window_decorations = "RESIZE"
    -- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
    -- config.integrated_title_button_alignment = "Right"
    -- config.integrated_title_buttons = { "Hide", "Close" }

    -- set tab-bar font
    config.use_fancy_tab_bar = false
    config.colors = { tab_bar = { background = "#1e2132" } }

    -- set tab-bar title
    wezterm.on(
        "format-tab-title",
        function(tab, tabs, panes, config, hover, max_width)
            local default_bg = "#1e2132"
            local default_fg = "#c6c8d1"
            local background = default_bg

            if tab.is_active then
                background = "#2e3244"
            elseif hover then
                background = "#2e3244"
            end

            return wezterm.format({
                { Background = { Color = default_bg } },
                { Foreground = { Color = background } },
                { Text = "" },
                { Background = { Color = background } },
                { Foreground = { Color = default_fg } },
                { Text = " " },
                { Text = string.format("%s", tab.tab_index + 1) },
                { Text = " " },
                { Background = { Color = background } },
                { Foreground = { Color = default_bg } },
                { Text = "" },
                "ResetAttributes",
            })
        end
    )
    -- set right tab status
    wezterm.on(
        "update-right-status",
        function(window, pane)
            Right.cells = {}
            Right.set_date()
            -- Right.set_battery()

            window:set_right_status(wezterm.format(Right.cells))

            window:set_left_status(wezterm.format({
                { Background = { Color = "#454b68" } },
                { Foreground = { Color = "#c6c8d1" } },
                { Text = " " },
                { Text = window:active_workspace() },
                { Text = " " },
                { Background = { Color = "#454b68" } },
                { Foreground = { Color = "#1e2132" } },
                { Text = "" },
            }))
        end
    )
    -- on startup
    -- wezterm.on("gui-startup", function(cmd)
    --     local tab, pane, window = mux.spawn_window(cmd or {})
    --     window:gui_window():toggle_fullscreen()
    -- end)
end

return Tabs
