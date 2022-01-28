local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi


local notification_center_border = wibox.widget({
    bg = beautiful.border_normal,
    forced_width = beautiful.notification_center_border_width,
    widget = wibox.container.background,
})

local styles = {}

styles.focus   = {
  fg_color = beautiful.accent5,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
}

styles.header  = {
  padding = 5,
  fg_color = beautiful.fg_focus,
  markup   = function(t) return '<b>' .. t .. '</b>' end,
}
styles.weekday = {
  padding = 0,
}
styles.normal = {
  padding = 0,
}

local function decorate_cell(widget, flag, date)
  local props = styles[flag] or {}

  if props.markup and widget.get_text and widget.set_markup then
    widget:set_markup(props.markup(widget:get_text()))
  end
  -- Get current weekday
  local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
  local weekday = tonumber(os.date("%w", os.time(d)))

  -- Weekends bold text
  if (weekday==0 or weekday==6) then
    widget:set_markup('<b>' .. widget:get_text() .. '</b>')
  end
  local default_fg = (weekday==0 or weekday==6) and beautiful.fg_focus
  local ret = wibox.widget {
    {
      widget,
      margins = props.padding or 0,
      widget = wibox.container.margin,
    },
    fg           = props.fg_color or default_fg,
    widget       = wibox.container.background
  }
  return ret
end

local calendar = wibox.widget({
    {
      {
        {
          nil,
          {
            date = os.date("*t"),
            font = "inter 11",
            long_weekdays = true,
            fn_embed = decorate_cell,
            widget = wibox.widget.calendar.month,
          },
          layout = wibox.layout.align.horizontal,
          expand = "outside",
        },
        top = dpi(25),
        bottom = dpi(25),
        widget = wibox.container.margin,
      },
      widget = wibox.container.background,
      bg = beautiful.border_normal,
    },
    layout = wibox.layout.align.vertical,
})

screen.connect_signal(
  "request::desktop_decoration",
  function(scr)

    gears.debug.dump(scr.geometry.width)

    local notification_center = wibox({
        visible = false,
        ontop = true,
        type = "dock",
        bg = beautiful.bg_normal .. beautiful.notification_center_opacity,
        screen = scr,
        x = (scr.geometry.width * scr.index) - beautiful.notification_center_width,
        y = beautiful.bar_height,
        height = scr.geometry.height - beautiful.bar_height,
        width = beautiful.notification_center_width
    })


    notification_center:setup{
      notification_center_border,
      calendar,
      fill_space = false,
      layout = wibox.layout.align.horizontal,
    }

    scr.notification_center = notification_center
  end
)

local notification_center_toggle = function()

  local focused = awful.screen.focused()

  local isVisible = focused.notification_center.visible

  for s in screen do
    s.notification_center.visible = false
  end

  focused.notification_center.visible = not isVisible

end

awesome.connect_signal("notificationcenter::toggle", notification_center_toggle)
