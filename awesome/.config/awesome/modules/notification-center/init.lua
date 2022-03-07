local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local rubato = require("lib.rubato")
local calendar = require("modules.notification-center.notification-calendar")

local notification_center_border = wibox.widget({
    bg = beautiful.border_normal,
    forced_width = beautiful.notification_center_border_width,
    widget = wibox.container.background,
})

screen.connect_signal("request::desktop_decoration",
  function (s)

    local widget = wibox ({
        visible = false,
        ontop = true,
        type = "dock",
        bg = beautiful.bg_normal .. beautiful.notification_center_opacity,
        x = (s.geometry.width * s.index) - beautiful.notification_center_width,
        y = beautiful.bar_height,
        screen = s,
        height = s.geometry.height - beautiful.bar_height,
        width = beautiful.notification_center_width,
        opacity = 0,
    })

    widget:setup({
        notification_center_border,
        calendar,
        fill_space = false,
        layout = wibox.layout.align.horizontal
    })

    local timer = rubato.timed {
      intro = 0.1,
      duration = 0.2,
      rate = 75,
      awestore_compat = true,
      subscribed = function (pos)
        widget.opacity = pos
      end

    }

    timer.ended:subscribe(function ()
        if widget.opacity == 0.0 then
          widget.visible = false
        end
    end)

    timer.started:subscribe(function ()
        if widget.opacity == 0.0 then
          widget.visible = true
        end
    end)

    s.notification_center = widget
    s.notification_center_animation = timer
end)


  local notification_center_toggle = function()

    local focused = awful.screen.focused()

    local isVisible = focused.notification_center.visible

    if isVisible then
      focused.notification_center_animation.target = 0
      awesome.emit_signal("notification_center::closed")
    else
      for s in screen do
        s.notification_center_animation.target = 0
      end
      focused.notification_center_animation.target = 1
      awesome.emit_signal("notification_center::opened")
    end

  end

  awesome.connect_signal("notificationcenter::toggle", notification_center_toggle)
