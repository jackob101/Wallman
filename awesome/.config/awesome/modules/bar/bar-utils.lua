local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local M = {}

local spacing_widget = wibox.widget({
	widget = wibox.container.background,
	forced_width = dpi(8),
})

function M.add_with_space(widget)
	return wibox.widget({
		widget,
		spacing_widget,
		layout = wibox.layout.fixed.horizontal,
	})
end

function M.create_spacing_widget()
	local function create_ball()
		return wibox.widget({
			widget = wibox.container.background,
			shape = gears.shape.circle,
			forced_width = dpi(4),
			forced_height = dpi(4),
			bg = beautiful.fg_normal,
		})
	end

	return wibox.widget({
		{
			create_ball(),
			create_ball(),
			create_ball(),
			layout = wibox.layout.align.vertical,
		},
		widget = wibox.container.margin,
		top = 5,
		bottom = 5,
	})
end

return M
