local awful = require("awful")
local wibox = require("wibox")
local initTagList = require("widgets.taglist.init")
local initTaskList = require("widgets.tasklist.init")
local volume_widget = require("widgets.volume-widget.volume")
local calendar_widget = require("widgets.calendar-widget.calendar")
local icons = require("icons")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")
local macros_widget = require("widgets.macros-status")
local notification_center_button = require("widgets.notification-center-button")
-- local gears = require("gears")


local clock_widget = utils.create_widget_with_icon(icons.clock, "fa-clock", wibox.widget.textclock())

local cw = calendar_widget({
    theme = "naughty",
    placement = "top_right",
    radius = 0,
})

clock_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      cw.toggle()
    end
end)

local keyboard_widget = utils.create_widget_with_icon(icons.keyboard, "fa-keyboard", awful.widget.keyboardlayout())

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

local spacing_widget = wibox.widget {
  widget = wibox.container.background,
  forced_width = dpi(8),
}

local function add_with_space(w)

  return wibox.widget {
    w,
    spacing_widget,
    layout = wibox.layout.fixed.horizontal,
  }
end

awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = initTagList(s)

    -- Create a tasklist widget
    s.mytasklist = initTaskList(s)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = beautiful.bar_height})

    -- systray
    s.systray = wibox.widget({
        {
          screen = "primary",
          widget = wibox.widget.systray,
        },
        spacing_widget,
        layout = wibox.layout.fixed.horizontal,
    })

    s.systray.visible = true

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          logo,
          s.mytaglist,
        },
        {
          layout = wibox.container.margin,
          left = 20,
          s.mytasklist,
        },
        { -- Right widgets
          {
            layout = wibox.layout.fixed.horizontal,
            add_with_space(macros_widget),
            add_with_space(volume_widget()),
            add_with_space(keyboard_widget),
            add_with_space(clock_widget),
            s.systray,
            add_with_space(notification_center_button),
          },
          top = 5,
          bottom = 5,
          widget = wibox.container.margin,
        },
    })
end)

