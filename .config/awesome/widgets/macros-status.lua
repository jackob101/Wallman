local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local widget = wibox.widget ({
    {
      markup = "<b>Macros ON</b>",
      widget = wibox.widget.textbox,
    },
    fg = beautiful.accent3,
    widget = wibox.container.background,
})

widget:connect_signal("button::release", function ()
    awesome.emit_signal("macros::toggle");
end)

local widget_tooltip = awful.tooltip {
  objects = {widget},
  text = "Click to turn off",
  margins = beautiful.tooltip_margins,
  shape = gears.shape.rounded_rect,
}

local update_widget = function (v)
  widget.visible = v
end

awesome.connect_signal("macros::update", update_widget)

return widget
