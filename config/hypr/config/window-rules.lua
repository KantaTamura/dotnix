--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
	name = "windowrule-0",
	opacity = "0.85 0.85",
	match = { class = "^(org.wezfurlong.wezterm)$" },
})

hl.window_rule({
	name = "windowrule-1",
	opacity = "0.85 0.85",
	match = { class = "^(footclient)$" },
})

hl.window_rule({
	name = "windowrule-2",
	opacity = "0.85 0.85",
	match = { class = "^(neovide)$" },
})

hl.window_rule({
	name = "windowrule-3",
	opacity = "0.80 0.80",
	float = true,
	size = { 600, 400 },
	match = { class = "(clipse)" },
})

hl.window_rule({
	name = "windowrule-4",
	opacity = "0.80 0.80",
	match = { class = "^([Ss]potify)$" },
})

hl.window_rule({
	name = "windowrule-5",
	opacity = "0.90 0.90",
	match = { class = "^([Ff]irefox)$" },
})

hl.window_rule({
	name = "windowrule-6",
	opacity = "0.90 0.90",
	match = { class = "^([Cc]ode)$" },
})

hl.window_rule({
	name = "windowrule-7",
	opacity = "0.90 0.90",
	match = { class = "^([Vv]esktop)$" },
})

hl.window_rule({
	name = "windowrule-8",
	opacity = "0.90 0.90",
	match = { class = "^(Postman)$" },
})

hl.window_rule({
	name = "windowrule-9",
	opacity = "0.85 0.85",
	workspace = "special:monitor silent",
	pin = true,
	match = { class = "^(btop-term)$" },
})

-- floating window

hl.window_rule({
	name = "windowrule-10",
	float = true,
	match = { class = "^(OpenRGB)$" },
})

hl.window_rule({
	name = "windowrule-11",
	float = true,
	size = { 600, 400 },
	match = { class = "(.blueman-manager-wrapped)" },
})

hl.window_rule({
	name = "windowrule-12",
	float = true,
	size = { 600, 400 },
	match = { class = "(org.pulseaudio.pavucontrol)" },
})

hl.window_rule({
	name = "windowrule-13",
	float = true,
	match = { class = "(org.kde.ark)" },
})

hl.window_rule({
	name = "windowrule-14",
	float = true,
	match = { class = "^(com.onepassword.OnePassword)$" },
})

hl.window_rule({
	name = "windowrule-15",
	float = true,
	size = { 3400, 1800 },
	match = { class = "(foot-floating-window)" },
})

hl.window_rule({
	name = "windowrule-16",
	float = true,
	size = { 600, 400 },
	match = { class = "(org.raspberrypi.rpi-imager)" },
})

-- special workspace rules

hl.window_rule({
	name = "windowrule-17",
	workspace = "special:mail silent",
	pin = true,
	match = { class = "(org.mozilla.Thunderbird)" },
})

hl.window_rule({
	name = "windowrule-18",
	workspace = "special:music silent",
	pin = true,
	match = { class = "^(spotify)$" },
})

hl.window_rule({
	name = "windowrule-19",
	workspace = "special:notes silent",
	pin = true,
	match = { class = "^(md.obsidian.Obsidian)$" },
})

hl.window_rule({
	name = "windowrule-20",
	workspace = "special:comms silent",
	pin = true,
	match = { class = "^(slack)$" },
})

hl.window_rule({
	name = "windowrule-21",
	workspace = "special:comms silent",
	pin = true,
	match = { class = "^(discord)$" },
})

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
	name = "windowrule-22",
	suppress_event = "maximize",
	match = { class = ".*" },
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "windowrule-23",
	no_focus = true,
	match = {
		class = "^$",
		title = "^$",
		xwayland = 1,
		float = 1,
		fullscreen = 0,
		pin = 0,
	},
})

hl.layer_rule({
	name = "layerrule-0",
	match = { namespace = "^rofi$" },
	blur = true,
	ignore_alpha = 0,
	animation = "slide",
})
