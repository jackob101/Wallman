local awful = require("awful")
local wibox = require("wibox")
local volume_widget = require("widgets.volume-widget.volume")
local calendar_widget = require("modules.bar.calendar")
local icons = require("icons")
local beautiful = require("beautiful")
local utils = require("utils")
local macros_widget = require("modules.bar.macros-status")
local notification_center_button = require("modules.notification-center.notification-center-button")
local bar_utils = require("modules.bar.bar-utils")
local dpi = beautiful.xresources.apply_dpi

local time_widget = utils.create_widget_with_icon(icons.clock, "fa-clock", wibox.widget.textclock())
local keyboard_widget = utils.create_widget_with_icon(icons.keyboard, "fa-keyboard", awful.widget.keyboardlayout())
utils.hover_effect(time_widget)

local callendar_widget = calendar_widget({
	theme = "naughty",
	placement = "top_right",
	radius = 0,
})

time_widget:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		callendar_widget.toggle()
	end
end)

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])

	-- Create a taglist widget
	s.mytaglist = require("modules.bar.taglist").initTagList(s)

	-- Create a tasklist widget
	s.mytasklist = require("modules.bar.tasklist").initTaskList(s)

	-- Create the wibar
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = beautiful.bar_height,
		bg = "#FFFFFF00",
		-- margins = {
		-- 	top = dpi(5),
		-- 	left = dpi(10),
		-- 	right = dpi(10),
		-- },
	})

	-- systray
	s.systray = wibox.widget({
		screen = "primary",
		widget = wibox.widget.systray,
		visible = true,
	})

	local left_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		require("modules.bar.launcher").create(),
		s.mytaglist,
		{
			widget = wibox.container.background,
			forced_width = dpi(5),
		},
		bar_utils.create_spacing_widget(),
	})

	local middle_widget = wibox.container({
		nil,
		s.mytasklist,
		layout = wibox.layout.align.horizontal,
		expand = "outside",
	})

	local right_widget = wibox.widget({
		{
			layout = wibox.layout.fixed.horizontal,
			bar_utils.add_with_space(macros_widget),
			bar_utils.add_with_space(volume_widget()),
			bar_utils.add_with_space(keyboard_widget),
			bar_utils.add_with_space(time_widget),
			bar_utils.add_with_space(s.systray),
			bar_utils.add_with_space(notification_center_button),
		},
		top = 5,
		bottom = 5,
		widget = wibox.container.margin,
	})

	local real_bar = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_normal .. beautiful.bar_opacity,
		{
			layout = wibox.layout.stack,
			{
				layout = wibox.layout.align.horizontal,
				expand = "inside",
				left_widget,
				nil,
				right_widget,
			},
			middle_widget,
		},
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		expand = "outside",
		real_bar,
	})
end)
