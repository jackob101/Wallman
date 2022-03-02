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
local gears = require("gears")
local logo = require("widgets.bar-logo")


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

local spacing_widget = wibox.widget {
  widget = wibox.container.background,
  forced_width = dpi(8),
}

local function add_with_space(widget)
  return wibox.widget {
    widget,
    spacing_widget,
    layout = wibox.layout.fixed.horizontal,
  }
end

local function create_spacing_widget()

  local function create_ball()
    return wibox.widget{
      widget = wibox.container.background,
      shape = gears.shape.circle,
      forced_width = dpi(4),
      forced_height = dpi(4),
      bg = beautiful.fg_normal,
    }
  end

  return wibox.widget{
    {
      create_ball(),
      create_ball(),
      create_ball(),
      layout = wibox.layout.align.vertical,
    },
    widget = wibox.container.margin,
    top = 5,
    bottom = 5,
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
        height = beautiful.bar_height,
        -- bg = "#ffffff00",
        bg = beautiful.bg_normal,
        shape = function(c, width, height)
          return gears.shape.rounded_rect(c, width, height, 5)
        end,
        margins = {
          top = dpi(5),
          left = dpi(10),
          right = dpi(10),
        } ,
    })

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

    local left_widget = wibox.widget{
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = 10,
        s.mytaglist,
        create_spacing_widget()
      },
      widget = wibox.container.background,
      bg = beautiful.bg_normal
    }

    local middle_widget = wibox.container {
      nil,
      s.mytasklist,
      layout = wibox.layout.align.horizontal,
      expand = "outside",
    }

    local right_widget = wibox.widget{
      {
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
      widget = wibox.container.background,
      shape = function (cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, 5)
      end,
      bg = beautiful.bg_normal,
    }

    local real_bar = wibox.widget{
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        expand = "inside",
        left_widget,
        nil,
        right_widget
      },
      middle_widget
    }

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        expand = "outside",
        real_bar
    })

end)
