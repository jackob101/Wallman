local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("icons")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")

local stylesheet = ""
	.. "#rect1 { fill: "
	.. beautiful.accent2
	.. ";}"
	.. "#rect2 { fill: "
	.. beautiful.accent3
	.. ";}"
	.. "#rect3 { fill: "
	.. beautiful.accent4
	.. ";}"
	.. "#rect4 { fill: "
	.. beautiful.accent5
	.. ";}"

local M = {}
function M.create()
	local widget = wibox.widget({
		{
			{
				nil,
				{
					image = icons.launcher,
					widget = wibox.widget.imagebox,
					stylesheet = stylesheet,
				},
				layout = wibox.layout.align.horizontal,
				expand = "outside",
			},
			margins = dpi(6),
			widget = wibox.container.margin,
		},
		forced_width = beautiful.bar_height + dpi(10),
		widget = wibox.container.background,
	})

	utils.hover_effect(widget)
	utils.generate_tooltip(widget, "Application launcher")

	widget:connect_signal("button::press", function()
		awful.spawn(os.getenv("HOME") .. "/.config/rofi/launcher.sh")
		widget:emit_signal("mouse::leave")
	end)

	return widget
end

return M
