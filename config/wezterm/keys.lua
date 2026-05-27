local wezterm = require("wezterm")
local act = wezterm.action

local Keys = {}

function Keys.setup(config)
    config.disable_default_key_bindings = true
    -- key bindings
    config.keys = {
        -- navigation
        { key = "o",   mods = "ALT",            action = "ShowTabNavigator" },
        -- arrow key binding
        { key = 'h',   mods = 'CTRL',           action = act.SendKey { key = 'LeftArrow' } },
        { key = 'j',   mods = 'CTRL',           action = act.SendKey { key = 'DownArrow' } },
        { key = 'k',   mods = 'CTRL',           action = act.SendKey { key = 'UpArrow' } },
        { key = 'l',   mods = 'CTRL',           action = act.SendKey { key = 'RightArrow' } },
        -- move pane
        { key = "h",   mods = "ALT",            action = act({ ActivatePaneDirection = "Left" }) },
        { key = "l",   mods = "ALT",            action = act({ ActivatePaneDirection = "Right" }) },
        { key = "k",   mods = "ALT",            action = act({ ActivatePaneDirection = "Up" }) },
        { key = "j",   mods = "ALT",            action = act({ ActivatePaneDirection = "Down" }) },
        -- move tab
        { key = "h",   mods = "ALT|SHIFT",      action = act({ ActivateTabRelative = -1 }) },
        { key = "l",   mods = "ALT|SHIFT",      action = act({ ActivateTabRelative = 1 }) },
        -- close pane or tab
        { key = "q",   mods = "ALT",            action = wezterm.action.CloseCurrentPane({ confirm = false }) },
        { key = "Q",   mods = "ALT",            action = act({ CloseCurrentTab = { confirm = false } }) },
        -- split pane
        { key = "-",   mods = "ALT",            action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
        { key = "\\",  mods = "ALT",            action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
        -- new tab
        { key = "n",   mods = "ALT",            action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
        { key = 'n',   mods = 'ALT|SHIFT',      action = wezterm.action.ShowLauncher },
        -- copy mode
        { key = "y",   mods = "CTRL",           action = wezterm.action.ActivateCopyMode },
        { key = "a",   mods = "ALT",            action = "QuickSelect" },
        -- copy & paste
        { key = "C",   mods = "SHIFT|CTRL",     action = { CopyTo = "Clipboard" } },
        { key = "V",   mods = "SHIFT|CTRL",     action = { PasteFrom = "Clipboard" } },
        -- font size
        { key = "=",   mods = "CTRL",           action = wezterm.action.IncreaseFontSize },
        { key = "-",   mods = "CTRL",           action = wezterm.action.DecreaseFontSize },
        -- tab switch by number
        { key = "1",   mods = "ALT",            action = wezterm.action({ ActivateTab = 0 }) },
        { key = "2",   mods = "ALT",            action = wezterm.action({ ActivateTab = 1 }) },
        { key = "3",   mods = "ALT",            action = wezterm.action({ ActivateTab = 2 }) },
        { key = "4",   mods = "ALT",            action = wezterm.action({ ActivateTab = 3 }) },
        { key = "5",   mods = "ALT",            action = wezterm.action({ ActivateTab = 4 }) },
        { key = "6",   mods = "ALT",            action = wezterm.action({ ActivateTab = 5 }) },
        { key = "7",   mods = "ALT",            action = wezterm.action({ ActivateTab = 6 }) },
        { key = "8",   mods = "ALT",            action = wezterm.action({ ActivateTab = 7 }) },
        { key = "9",   mods = "ALT",            action = wezterm.action({ ActivateTab = 8 }) },
        -- resize pane
        { key = "h",   mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Left", 1 } }) },
        { key = "l",   mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Right", 1 } }) },
        { key = "k",   mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Up", 1 } }) },
        { key = "j",   mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Down", 1 } }) },
        -- zoom pane
        { key = "z",   mods = "ALT",            action = wezterm.action.TogglePaneZoomState },
        -- toggle full screen
        { key = "F11", mods = "",               action = wezterm.action.ToggleFullScreen },
        -- workspace
        { key = "d",   mods = "ALT",            action = act.SwitchToWorkspace { name = "default" } },
        { key = "w",   mods = "ALT",            action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
        {
            key = "w", mods = "ALT|SHIFT",
            action = act.PromptInputLine {
                description = wezterm.format {
                    { Attribute = { Intensity = 'Bold' } },
                    { Foreground = { AnsiColor = 'Fuchsia' } },
                    { Text = 'Enter name for new workspace' },
                },
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:perform_action(
                            act.SwitchToWorkspace {
                                name = line,
                            },
                            pane
                        )
                    end
                end),
            },
        },
    }
    -- mouse bindings
    config.mouse_bindings = {
        -- disable middle click
        { event = { Up   = { streak = 1, button = "Middle" } }, mods = "NONE", action = act.Nop },
        { event = { Down = { streak = 1, button = "Middle" } }, mods = "NONE", action = act.Nop },
    }
end

return Keys
