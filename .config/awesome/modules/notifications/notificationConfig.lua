local ruled = require("ruled")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = beautiful.xresources
local awful = require("awful")
local xrdb = xresources.get_current_theme()
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")

ruled.notification.connect_signal("request::rules", function()

    ruled.notification.append_rule {
      rule       = { urgency = "critical" },
      properties =
        {
          timeout = 0,
          border_color = beautiful.bg_urgent,
        }
    }

    -- Or green background for normal ones.
    ruled.notification.append_rule {
      rule       = { urgency = "normal" },
      properties = {
        timeout = 5,
      }
    }
end)

naughty.connect_signal("request::display",
  function (n)

    local left_part = wibox.widget {
      {
        {
          {
            naughty.widget.icon,
            widget = wibox.container.background,
          },
          valign = "center",
          widget = wibox.container.place,
        },
        left = 10,
        right = 10,
        expand = "outside",
        widget = wibox.container.margin,
      },
      forced_width = dpi(70),
      bg = beautiful.bg_focus,
      widget = wibox.container.background,
    }

    local right_part = wibox.widget {

      {

        {
          align = "center",
          markup = "<b>" .. n.title .. "</b>",
          font = beautiful.notification_title_font,
          ellipsize = "end",
          widget = wibox.widget.textbox,
          forced_height = 25,
        },
        {
          {
            align = "center",
            valign = "top",
            wrap = "char",
            widget = naughty.widget.message,
          },
          top = 5,
          widget = wibox.container.margin,
        },
        expand = "inside",
        spacing = 5,
        layout = wibox.layout.align.vertical,

      },
      margins = beautiful.notification_box_margin,
      widget = wibox.container.margin,
    }

    naughty.layout.box {
      notification = n,
      type = "notification",
      screen = awful.screen.focused(),
      shape = gears.shape.rectangle,
      bg = "#FFFFFF00",
      widget_template = {
        {
          {
            {
              left_part,
              right_part,
              layout = wibox.layout.align.horizontal,
            },
            strategy = 'max',
            height = beautiful.notification_height,
            widget = wibox.container.constraint,
          },
          strategy = 'exact',
          width = beautiful.notification_width,
          widget = wibox.container.constraint,
        },
        -- border_color = beautiful.accent5 ,
        -- border_width = 2,
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_normal,
        widget = wibox.container.background,
      }
    }
  end
)

naughty.connect_signal("request::destroyed",
  function (r, keep)


end)
