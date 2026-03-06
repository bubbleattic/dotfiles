local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.keys = {
	{
		key = "%",
		mods = "SHIFT|CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "SHIFT|CTRL",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "Enter",
		mods = "SHIFT|CTRL",
		action = wezterm.action_callback(function(window, pane)
			local dim = pane:get_dimensions()
			if dim.pixel_width > dim.pixel_height then
				pane:split({ direction = "Right" })
			else
				pane:split({ direction = "Bottom" })
			end
		end),
	},
}
return config
