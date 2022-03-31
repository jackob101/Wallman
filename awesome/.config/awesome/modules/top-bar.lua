local awful = require("awful")
local wibox = require("wibox")
local tagList = require("widgets.taglist")
local taskList = require("widgets.tasklist")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local function create_spacing_widget()
	local function create_ball()
		return wibox.widget({
			widget = wibox.container.background,
			shape = gears.shape.circle,
			forced_width = dpi(4),
			forced_height = dpi(4),
			bg = beautiful.fg_normal,
		})
	end

	return wibox.widget({
		{
			create_ball(),
			create_ball(),
			create_ball(),
			layout = wibox.layout.align.vertical,
		},
		widget = wibox.container.margin,
		top = 5,
		bottom = 5,
	})
end

local function add_with_margin(w, t, r, b, l)
	local default_vertical_margin = dpi(9)
	local default_right_margin = dpi(10)

	return wibox.widget({
		w,
		widget = wibox.container.margin,
		top = t or default_vertical_margin,
		right = r or default_right_margin,
		bottom = b or default_vertical_margin,
		left = l or 0,
	})
end

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
		bg = beautiful.bg_normal .. beautiful.bar_opacity,
	})

	-- Add spacing only after tags and divider widget
	local left_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		require("widgets.launcher").create(),
		{
			{
				{
					{
						widget = wibox.container.background,
						forced_width = dpi(2),
						bg = beautiful.fg_normal,
					},
					widget = wibox.container.margin,
					left = dpi(5),
					right = dpi(5),
				},
				s.mytaglist,
				{
					{
						widget = wibox.container.background,
						forced_width = dpi(2),
						bg = beautiful.fg_normal,
					},
					widget = wibox.container.margin,
					left = dpi(5),
					right = dpi(5),
				},
				layout = wibox.layout.fixed.horizontal,
			},
			widget = wibox.container.margin,
			top = dpi(2),
			bottom = dpi(2),
		},
		s.mytasklist,
	})

	-- s.systray = wibox.widget({
	-- 	screen = "primary",
	-- 	widget = wibox.widget.systray,
	-- 	visible = true,
	-- })
	local volume_widget = require("widgets.volume")

	local right_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		add_with_margin(require("widgets.layout")(s)),
		add_with_margin(volume_widget),
		add_with_margin(require("widgets.time-date")(s)),
		add_with_margin(require("widgets.central_panel_toggle")()),
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		expand = "outside",
		widget = wibox.container.background,
		{
			layout = wibox.layout.align.horizontal,
			expand = "inside",
			left_widget,
			nil,
			right_widget,
		},
	})
end)
