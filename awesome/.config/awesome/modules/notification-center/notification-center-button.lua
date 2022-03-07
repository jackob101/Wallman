local icons = require("icons")
local wibox = require("wibox")
local utils = require("utils")


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

utils.hover_effect(button_wrapper)

local toggle_closed = function ()
  button.image = icons.notification_center_open
end

local toggle_opened = function ()
  button.image = icons.notification_center_close
end

button_wrapper:connect_signal("button::press", function ()
  awesome.emit_signal("notificationcenter::toggle")
end)

awesome.connect_signal("notification_center::closed", toggle_closed)
awesome.connect_signal("notification_center::opened", toggle_opened)

return button_wrapper
