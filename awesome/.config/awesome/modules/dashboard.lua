local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local config = beautiful.dashboard


local dashboard = awful.popup{
    widget = {
        {
           widget = wibox.widget.textbox,
           text = "Test",
        },
        layout = wibox.layout.align.horizontal,
    },
    placement = awful.placement.centered,
    ontop = true,
    --x = 0,
    width = 200,
    height = 200,
    bg  = "#FFFFFF",
    --y = 0,
    visible = false,
}

awesome.connect_signal("dashboard::toggle", function()
    dashboard.visible = not dashboard.visible
end)
