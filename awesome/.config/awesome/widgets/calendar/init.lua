local wibox = require("wibox")
local icons = require("icons")
local beautiful = require("beautiful")

local function create(s)
	local calendar = wibox.widget({
		widget = wibox.widget.textclock,
		format = "%d-%m-%Y",
		font = beautiful.bar_font,
	})

	local stylesheet = "#image{fill:" .. beautiful.accent4 .. ";}"

	s.calendar = wibox.widget({
		{
			{
				{
					image = icons.calendar,
					widget = wibox.widget.imagebox,
					stylesheet = stylesheet,
				},
				widget = wibox.container.margin,
				margins = beautiful.bar_icon_margin,
			},
			calendar,
			font = beautiful.bar_font,
			spacing = beautiful.bar_icon_text_spacing,
			layout = wibox.layout.fixed.horizontal,
		},
    widget = wibox.container.background,
    fg = beautiful.accent4
	})

	return s.calendar
end

return create
