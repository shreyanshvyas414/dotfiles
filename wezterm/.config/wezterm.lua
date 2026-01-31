-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- AESTHETICS

-- Background opacity and blur
config.window_background_opacity = 0.85
config.macos_window_background_blur = 16

-- Titlebar styling (macOS)
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = false

-- Font configuration
config.font = wezterm.font_with_fallback({
	{
		family = "Cascadia Code",
		weight = "Bold",
		harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
	},
})
config.font_size = 15.0
config.freetype_load_target = "Normal"
config.freetype_render_target = "HorizontalLcd"

-- Cursor configuration
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0
config.cursor_thickness = "1pt"

-- Underline adjustments (WezTerm handles this differently)
config.underline_position = "-4pt"
config.underline_thickness = "2pt"

-- Window size and padding
config.initial_cols = 120
config.initial_rows = 50
config.window_padding = {
	left = 4,
	right = 4,
	top = 4,
	bottom = 4,
}

-- Unfocused pane opacity
config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.0,
}

-- Disable confirmation dialogs
config.window_close_confirmation = "NeverPrompt"
config.skip_close_confirmation_for_processes_named = {}

-- TERMINAL SETTINGS

config.term = "xterm-256color"

-- Default shell
config.default_prog = { "/bin/zsh", "-l" }

-- THEME - Gruvbox Material Dark

config.color_scheme = "tokyonight_night"

-- If the above doesn't work, you can define colors manually:
-- config.colors = {
-- 	foreground = "#ddc7a1",
-- 	background = "#282828",
-- 	cursor_bg = "#ddc7a1",
-- 	cursor_fg = "#282828",
-- 	cursor_border = "#ddc7a1",
-- 	selection_fg = "#282828",
-- 	selection_bg = "#ddc7a1",
-- 	scrollbar_thumb = "#504945",
-- 	split = "#504945",
-- 	ansi = {
-- 		"#32302f",
-- 		"#ea6962",
-- 		"#a9b665",
-- 		"#d8a657",
-- 		"#7daea3",
-- 		"#d3869b",
-- 		"#89b482",
-- 		"#ddc7a1",
-- 	},
-- 	brights = {
-- 		"#32302f",
-- 		"#ea6962",
-- 		"#a9b665",
-- 		"#d8a657",
-- 		"#7daea3",
-- 		"#d3869b",
-- 		"#89b482",
-- 		"#ddc7a1",
-- 	},
-- }

-- KEYBINDINGS

config.keys = {
	-- Split pane to the right (Ctrl+D)
	{
		key = "d",
		mods = "CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Toggle fullscreen (Cmd+F11)
	{
		key = "F11",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
	-- Additional useful keybindings for pane navigation
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	-- Close current pane
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- Create new tab
	{
		key = "t",
		mods = "CMD",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	-- Navigate tabs
	{
		key = "[",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

-- TAB BAR

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.tab_max_width = 32

-- PERFORMANCE

config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.max_fps = 120
config.animation_fps = 60

-- MISC

-- Disable audible bell
config.audible_bell = "Disabled"

-- Automatically reload config
config.automatically_reload_config = true

-- Return the configuration to wezterm
return config
