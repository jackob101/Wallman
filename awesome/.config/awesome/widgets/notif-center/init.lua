local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local header = wibox.widget({
	widget = wibox.widget.textbox,
	valign = "center",
	halign = "left",
	text = "Notification center",
	font = "Inter bold 16",
})

local function create(s)
  local core = require("widgets.notif-center.notif-list")
	s.notiflist_layout = core.notiflist_layout
	s.clear_all = require("widgets.notif-center.clear-all")
	s.header = require("widgets.notif-center.header")
  core.connect_count(s.header.counter)


	return wibox.widget({
		{
			layout = wibox.layout.fixed.vertical,
			expand = "none",
			spacing = dpi(10),
			{
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
				widget = wibox.container.background,
				bg = beautiful.bg_overlay,
			},
			s.notiflist_layout,
		},
		widget = wibox.container.background,
		forced_width = dpi(350),
	})
end

return create
