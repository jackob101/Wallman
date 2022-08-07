local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local notif_center = require("widgets.notif-center")
local dpi = beautiful.xresources.apply_dpi
local theme = beautiful.notification_center

local function create(s)
	s.notif_center = notif_center(s)

	local panel = awful.popup({
		screen = s,
		visible = false,
		ontop = true,
		type = "dock",
		shape = gears.shape.rectangle,
		bg = theme.bg,
		border_width = theme.border_width,
		border_color = theme.border_color,
		maximum_width = beautiful.central_panel_max_width,
		maximum_height = beautiful.central_panel_max_height,
		minimum_height = beautiful.central_panel_max_height,
		minimum_width = beautiful.central_panel_max_width,
		width = beautiful.central_panel_max_width,
		height = beautiful.central_panel_max_height,
		widget = {
			widget = wibox.container.margin,
			margins = dpi(15),
			{
				widget = wibox.container.background,
				layout = wibox.layout.flex.horizontal,
				expand = "none",
				s.notif_center,
			},
		},
	})

	awful.placement.bottom_right(panel, {
		honor_workarea = true,
		margins = {
			bottom = beautiful.bar_height + dpi(5),
			right = dpi(5),
		},
	})

	s.central_backdrop = wibox({
		ontop = true,
		screen = s,
		bg = "#FFFFFF00",
		type = "utility",
		visible = false,
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height,
	})
	local open = false

	function panel:toggle()
		open = not open

		s.central_backdrop.visible = open
		self.visible = open
	end

	s.central_backdrop:buttons(awful.util.table.join(awful.button({}, 1, nil, function()
		panel:toggle()
	end)))

	return panel
end

return create
