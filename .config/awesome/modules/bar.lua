local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local initTagList = require("widgets.taglist.init")
local initTaskList = require("widgets.tasklist.init")
local volume_widget = require("widgets.volume-widget.volume")
local calendar_widget = require("widgets.calendar-widget.calendar")
local icons = require("img.icons")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local mykeyboardlayout = awful.widget.keyboardlayout()

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

local logo = wibox.widget {

  {
    image = icons.logo,
    resize = true,
    widget = wibox.widget.imagebox,
  },

  right = 5,
  left = 5,
  top = 2,
  bottom = 2,
  widget = wibox.container.margin,

}

awful.screen.connect_for_each_screen(function(s)
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
   s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(25) })

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
            logo,
            s.mytaglist,
            s.mypromptbox,
         },
         {
            layout = wibox.container.margin,
            left = 20,
            s.mytasklist,
         },
         { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            volume_widget(),
            mykeyboardlayout,
            mytextclock,
            s.systray,
            spacing = dpi(8),
         },
   })
end)

