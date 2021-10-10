local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local initTagList = require("widgets.taglist.init")
local initTaskList = require("widgets.tasklist.init")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local naughty = require("naughty")

mykeyboardlayout = awful.widget.keyboardlayout()

local mytextclock = wibox.widget.textclock()

local cw = calendar_widget({
	theme = "naughty",
	placement = "top_right",
	radius = 0,
})

mytextclock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	end
end)

-- Create a wibox for each screen and add it
local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = initTagList(s)

	-- Create a tasklist widget
	s.mytasklist = initTaskList(s)

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })

	-- systray

	s.systray = wibox.widget({
		{
			widget = wibox.widget.systray,
		},
		widget = wibox.container.margin,
		left = 10,
		right = 10,
	})
	s.systray.visible = false

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
			s.mypromptbox,
		},
		{
			layout = wibox.layout.margin,
			left = 20,
			s.mytasklist,
		},
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			volume_widget(),
			mykeyboardlayout,
			mytextclock,
			s.mylayoutbox,
			s.systray,
		},
	})
end)
-- }}}
