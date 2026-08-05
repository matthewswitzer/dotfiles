-- Pull in the wezterm API and initialize the config builder
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Color scheme
config.color_scheme = "OneDark (base16)"

-- Font
config.font = wezterm.font("FiraCode Nerd Font", { weight = 450 })
config.font_size = 13.2
config.line_height = 1.3

-- Image protocol
config.enable_kitty_graphics = true

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
	active_titlebar_bg = "#2d3139",
	inactive_titlebar_bg = "#2d3139",
}
config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = "#2d3139",
			fg_color = "#abb2bf",
		},
		inactive_tab = {
			bg_color = "#2d3139",
			fg_color = "#5f5f5f",
		},
		inactive_tab_hover = {
			bg_color = "#2d3139",
			fg_color = "#abb2bf",
		},
		new_tab = {
			bg_color = "#2d3139",
			fg_color = "#5f5f5f",
		},
		new_tab_hover = {
			bg_color = "#2d3139",
			fg_color = "#abb2bf",
		},
	},
}

-- Window close confirmation
config.window_close_confirmation = "NeverPrompt"

-- Window decorations
config.window_decorations = "TITLE | RESIZE | MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR"

-- Window padding
config.window_padding = {
	top = 0,
	left = 0,
	bottom = 0,
	right = 0,
}

-- Window size
config.initial_cols = 120
config.initial_rows = 30

return config
