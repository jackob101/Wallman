local wibox = require("wibox")
local beatiful = require("beautiful")
local dpi = beatiful.xresources.apply_dpi
local icons = require("icons")
local gears = require("gears")
local awful = require("awful")
local utils = require("utils")

local notif_core = require("widgets.notif-center.notif-list")

local function create_icon(icon)
	return wibox.widget({
		id = "icon",
		widget = wibox.widget.imagebox,
		resize = true,
		forced_width = dpi(40),
		forced_height = dpi(40),
		image = icon,
	})
end

local function create_title(title)
	return wibox.widget({
		id = "title",
		widget = wibox.widget.textbox,
		valign = "left",
		text = title,
		font = "Inter medium 12",
	})
end

local function create_dismiss()
	local dismiss_icon = wibox.widget({
		widget = wibox.widget.imagebox,
		image = icons.window_close,
		forced_height = dpi(10),
		forced_width = dpi(10),
		resize = true,
	})

	local dismiss_button = wibox.widget({
		visible = false,
		dismiss_icon,
		widget = wibox.container.margin,
		margins = dpi(4),
		shape = gears.shape.circle,
	})

	return dismiss_button
end

local function create_message(message)
	return wibox.widget({
		widget = wibox.widget.textbox,
		text = message,
	})
end

local function create(n)
	local dismiss = create_dismiss()

	local notification = wibox.widget({
		widget = wibox.container.background,
		bg = beatiful.bg_overlay,
		{
			widget = wibox.container.constraint,
			height = dpi(80),
			strategy = "min",
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 0,
				fill_space = true,
				{
					{
						widget = wibox.container.place,
						forced_width = dpi(40),
						valign = "center",
						halign = "center",
						create_icon(n.icon),
					},
					widget = wibox.container.margin,
					margins = dpi(10),
				},
				{
					{
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(5),
						{
							layout = wibox.layout.align.horizontal,
							create_title(n.title),
							nil,
							dismiss,
						},
						create_message(n.message),
					},
					widget = wibox.container.margin,
					margins = dpi(10),
				},
			},
		},
	})

	local notification_spacing = wibox.widget({
		notification,
		widget = wibox.container.margin,
		left = dpi(5),
		right = dpi(5),
	})

	local function notification_dismiss()
		notif_core.notiflist_layout:remove_widgets(notification_spacing, true)
    notif_core.update()
	end

	notification:buttons(awful.util.table.join(awful.button({}, 1, function()
		if #notif_core.notiflist_layout.children == 1 then
			notif_core.reset_list()
		else
			notification_dismiss()
		end
		collectgarbage("collect")
	end)))

	utils.cursor_hover(notification)

	notification:connect_signal("mouse::enter", function()
		notification.bg = beatiful.bg_hover
		dismiss.visible = true
	end)

	notification:connect_signal("mouse::leave", function()
		notification.bg = beatiful.bg_overlay
		dismiss.visible = false
	end)

	collectgarbage("collect")

	return notification_spacing
end

return create
