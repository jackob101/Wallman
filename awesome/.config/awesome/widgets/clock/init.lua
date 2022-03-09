local wibox = require("wibox")
local icons = require("icons")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local function create(s)
	local clock = wibox.widget({
		widget = wibox.widget.textclock,
		format = "%H:%M",
		font = beautiful.bar_font,
	})

	local stylesheet = "#image{fill: " .. beautiful.accent5 .. ";}"

	s.clock = wibox.widget({
		{
			{
				{
					{
						image = icons.clock,
						widget = wibox.widget.imagebox,
						stylesheet = stylesheet,
					},
					widget = wibox.container.margin,
					margins = beautiful.bar_icon_margin,
				},
				widget = wibox.container.background,
				fg = beautiful.fg_normal,
			},
			clock,
			font = beautiful.bar_font,
			spacing = beautiful.bar_icon_text_spacing,
			layout = wibox.layout.fixed.horizontal,
		},

		widget = wibox.container.background,
		fg = beautiful.accent5,
	})

	return s.clock
end

return create
