local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local notif_center = require("widgets.notif-center")

local function create(s)
	s.notif_center = notif_center(s)

	s.central_backdrop = wibox({
		ontop = true,
		screen = s,
		bg = "#FFFFFF55",
		type = "utility",
		visible = false,
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height,
	})

	local panel = awful.popup({
		screen = s,
		visible = false,
		ontop = true,
		placement = awful.placement.centered,
		type = "dock",
		shape = gears.shape.rectangle,
		maximum_width = beautiful.central_panel_max_width,
		maximum_height = beautiful.central_panel_max_height,
		minimum_height = beautiful.central_panel_max_height,
		minimum_width = beautiful.central_panel_max_width,
		widget = {},
	})

	panel:setup({
		bg = "#FF00FF",
		widget = wibox.container.background,
		layout = wibox.layout.flex.horizontal,
		expand = "inside",
		{
			widget = wibox.container.background,
			bg = "#FFFFFF",
		},
		nil,
		s.notif_center,
	})
	local open = false

	local keygrabber = awful.keygrabber({
    mask_event_callback = false,
		keypressed_callback = function(_, _, key)
			if key == "Escape" then
				panel:toggle()
			end
		end,
	})

	function panel:toggle()
		open = not open

		if open then
			keygrabber:start()
		elseif not open then
			keygrabber:stop()
		end

		s.central_backdrop.visible = open
		self.visible = open
	end

	s.central_backdrop:buttons(awful.util.table.join(awful.button({}, 1, nil, function()
		panel:toggle()
	end)))

	return panel
end

return create
