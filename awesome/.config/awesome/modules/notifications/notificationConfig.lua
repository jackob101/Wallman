local ruled = require("ruled")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")
local menubar = require("menubar")

local is_dnd_on = false

ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = { urgency = "critical" },
		properties = {
			timeout = 0,
			border_color = beautiful.bg_urgent,
			bg = beautiful.bg_urgent,
		},
	})

	ruled.notification.append_rule({
		rule = { urgency = "normal" },
		properties = {
			timeout = 5,
			bg = beautiful.color10,
		},
	})
end)

-- Some magic that fixed missing icons
naughty.connect_signal("request::icon", function(n, context, hints)
	if context ~= "app_icon" then
		return
	end

	local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

	if path then
		n.icon = path
	end
end)

awesome.connect_signal("modules::dnd:changed", function(new)
	is_dnd_on = new
end)

naughty.connect_signal("request::display", function(n)
	if not is_dnd_on then
		local left_part = wibox.widget({
			{
				naughty.widget.icon,
				widget = wibox.container.place,
				valign = "center",
				halign = "center",
			},
			forced_width = dpi(70),
			bg = n.bg,
			widget = wibox.container.background,
		})

		local right_part = wibox.widget({

			{

				{
					align = "center",
					markup = "<b>" .. n.title .. "</b>",
					font = beautiful.notification_title_font,
					ellipsize = "end",
					widget = wibox.widget.textbox,
					forced_height = 25,
				},
				{
					{
						align = "center",
						valign = "top",
						wrap = "char",
						widget = naughty.widget.message,
					},
					top = 5,
					widget = wibox.container.margin,
				},
				expand = "inside",
				spacing = 5,
				layout = wibox.layout.align.vertical,
			},
			margins = beautiful.notification_box_margin,
			widget = wibox.container.margin,
		})

		naughty.layout.box({
			notification = n,
			type = "notification",
			screen = awful.screen.focused(),
			shape = gears.shape.rectangle,
			bg = beautiful.bg_overlay,
			widget_template = {
				left_part,
				right_part,
				layout = wibox.layout.align.horizontal,
			},
		})
	end
end)

naughty.connect_signal("request::destroyed", function(_, _) end)
