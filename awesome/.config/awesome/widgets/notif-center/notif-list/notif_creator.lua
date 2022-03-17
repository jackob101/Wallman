local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")
local gears = require("gears")
local awful = require("awful")
local utils = require("utils")
local naughty = require("naughty")

local notif_core = require("widgets.notif-center.notif-list")

local function create_actions(n)
	local actions_template = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = dpi(0),
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = {
			{
				{
					{
						id = "text_role",
						font = "Inter Regular 10",
						widget = wibox.widget.textbox,
					},
					widget = wibox.container.place,
				},
				bg = beautiful.groups_bg,
				shape = gears.shape.rounded_rect,
				forced_height = 30,
				widget = wibox.container.background,
			},
			margins = 4,
			widget = wibox.container.margin,
		},
		style = { underline_normal = false, underline_selected = true },
		widget = naughty.list.actions,
	})

	return actions_template
end

local function create_icon(icon)
	return wibox.widget({
		layout = wibox.layout.fixed.vertical,
		{
			id = "icon",
			widget = wibox.widget.imagebox,
			resize = true,
			forced_width = dpi(25),
			forced_height = dpi(25),
			image = icon,
		},
	})
end

local function create_title(title)
	return wibox.widget({
		id = "title",
		widget = wibox.widget.textbox,
		valign = "left",
		text = title,
		font = "Inter medium 14",
	})
end

local function create_appname(app)
	return wibox.widget({
		id = "title",
		widget = wibox.widget.textbox,
		valign = "left",
		text = app,
		font = "Inter bold 12",
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
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
		{
			widget = wibox.container.margin,
			margins = dpi(5),
			dismiss_icon,
		},
	})

	return dismiss_button
end

local function create_message(message)
	return wibox.widget({
		widget = wibox.widget.textbox,
		text = message,
	})
end

local parse_to_seconds = function(time)
	local hourInSec = tonumber(string.sub(time, 1, 2)) * 3600
	local minInSec = tonumber(string.sub(time, 4, 5)) * 60
	local getSec = tonumber(string.sub(time, 7, 8))
	return (hourInSec + minInSec + getSec)
end

local return_date_time = function(format)
	return os.date(format)
end

local function create(n)
	local dismiss = create_dismiss()
	local time_of_pop = return_date_time("%H:%M:%S")
	local exact_time = return_date_time("%I:%M %p")
	local exact_date_time = return_date_time("%b %d, %I:%M %p")

	local notifbox_timepop = wibox.widget({
		id = "time_pop",
		markup = nil,
		font = "Inter Regular 10",
		align = "left",
		valign = "center",
		visible = true,
		widget = wibox.widget.textbox,
	})

	local time_of_popup = gears.timer({
		timeout = 60,
		call_now = true,
		autostart = true,
		callback = function()
			local time_difference = nil

			time_difference = parse_to_seconds(return_date_time("%H:%M:%S")) - parse_to_seconds(time_of_pop)
			time_difference = tonumber(time_difference)

			if time_difference < 60 then
				notifbox_timepop:set_markup("now")
			elseif time_difference >= 60 and time_difference < 3600 then
				local time_in_minutes = math.floor(time_difference / 60)
				notifbox_timepop:set_markup(time_in_minutes .. "m ago")
			elseif time_difference >= 3600 and time_difference < 86400 then
				notifbox_timepop:set_markup(exact_time)
			elseif time_difference >= 86400 then
				notifbox_timepop:set_markup(exact_date_time)
				return false
			end

			collectgarbage("collect")
		end,
	})

	local notification = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_overlay_transparent,
		{
			{
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(5),
				{
					expand = "none",
					layout = wibox.layout.align.horizontal,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(10),
						create_icon(n.icon),
						create_appname(n.app_name),
					},
					nil,
					{
						notifbox_timepop,
						dismiss,
						layout = wibox.layout.fixed.horizontal,
					},
				},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(10),
					{
						create_title(n.title),
						create_message(n.message),
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(5),
					},
					create_actions(n),
				},
			},
			margins = dpi(10),
			widget = wibox.container.margin,
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
		notification.bg = beautiful.bg_hover_transparent
		dismiss.visible = true
	end)

	notification:connect_signal("mouse::leave", function()
		notification.bg = beautiful.bg_overlay_transparent
		dismiss.visible = false
	end)

	collectgarbage("collect")

	return notification_spacing
end

return create
