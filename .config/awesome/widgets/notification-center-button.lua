local awful = require("awful")
local beautiful = require("beautiful")
local icons = require("icons.init")
local gears = require("gears")
local wibox = require("wibox")


local button_wrapper = wibox{
  visible = true,
  ontop = true,
}

local button = wibox.widget({
    image = icons.notification_center_open,
    widget = wibox.widget.imagebox,
})

button_wrapper:setup{
  button,
  valign = "center",
  layout = wibox.layout.place
}

return button_wrapper
