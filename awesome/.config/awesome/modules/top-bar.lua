local awful = require("awful")
local wibox = require("wibox")
local tagList = require("modules.bar.taglist")
local taskList = require("modules.bar.tasklist")
local beautiful = require("beautiful")
local macros_widget = require("modules.bar.macros-status")
local bar_utils = require("modules.bar.bar-utils")
local dpi = beautiful.xresources.apply_dpi

awful.screen.connect_for_each_screen(function(s)
	-- Create a taglist widget
	s.mytaglist = tagList.initTagList(s)

	-- Create a tasklist widget
	s.mytasklist = taskList.initTaskList(s)

	-- Create the wibar
	s.mywibox = awful.wibar({
		position = "bottom",
		screen = s,
		height = beautiful.bar_height,
		bg = beautiful.bg_overlay_transparent,
	})

	-- Add spacing only after tags and divider widget
	local left_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		require("modules.bar.launcher").create(),
		s.mytaglist,
		{
			widget = wibox.container.background,
			forced_width = dpi(5),
		},
		bar_utils.create_spacing_widget(),
		{
			widget = wibox.container.background,
			forced_width = dpi(5),
		},
		s.mytasklist,
	})

	-- s.systray = wibox.widget({
	-- 	screen = "primary",
	-- 	widget = wibox.widget.systray,
	-- 	visible = true,
	-- })

	local right_widget = wibox.widget({
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			bar_utils.add_with_space(macros_widget),
			-- s.systray,
			require("widgets.volume"),
			require("widgets.clock")(s),
			require("widgets.calendar")(s),
			require("widgets.central_panel_toggle")(),
		},
		top = 5,
		bottom = 5,
		right = dpi(10),
		widget = wibox.container.margin,
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		expand = "outside",
		widget = wibox.container.background,
		bg = beautiful.bg_normal .. beautiful.bar_opacity,
		{
			layout = wibox.layout.align.horizontal,
			expand = "inside",
			left_widget,
			nil,
			right_widget,
		},
	})
end)
