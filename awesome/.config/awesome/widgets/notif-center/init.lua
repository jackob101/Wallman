local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local function create(s)
	local core = require("widgets.notif-center.notif-list")
	s.notiflist_layout = core.notiflist_layout
	s.clear_all = require("widgets.notif-center.clear-all")
	s.header = require("widgets.notif-center.header")
	core.connect_count(s.header.counter)

	return wibox.widget({
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(5),
		widget = wibox.container.background,
		forced_width = dpi(350),
		{
				{
					layout = wibox.layout.align.horizontal,
					spacing = dpi(20),
					expand = "inside",
					s.header.widget,
					nil,
					s.clear_all,
				},
				widget = wibox.container.margin,
				margins = dpi(10),
		},
		s.notiflist_layout,
	})
end

return create
