local awful = require("awful")
local beautiful = require("beautiful")
local icons = require("icons.init")
local gears = require("gears")
local wibox = require("wibox")


local button = wibox.widget(
  {
    image = icons.notification_center_open,
    widget = wibox.widget.imagebox,
})

local button_wrapper = wibox.widget({
    button,
    left = 2,
    right = 2,
    widget = wibox.container.margin,
})

local toggle_closed = function ()
  button.image = icons.notification_center_open
end

local toggle_opened = function ()
  button.image = icons.notification_center_close
end

awesome.connect_signal("notification_center::closed", toggle_closed)
awesome.connect_signal("notification_center::opened", toggle_opened)

return button_wrapper
