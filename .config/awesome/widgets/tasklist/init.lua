local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

function initTaskList(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		layout = {
			spacing = 10,
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						id = "icon_role",
						widget = wibox.widget.imagebox,
					},
					spacing = 10,
					{

						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				widget = wibox.container.margin,
				left = 5,
				right = 5,
			},
			id = "background_role",
			widget = wibox.container.background,
			forced_width = 250,
		},
		buttons = tasklist_buttons,
	})
end

return initTaskList
