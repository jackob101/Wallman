local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("icons")

local function create()
    local clock = wibox.widget({
        widget = wibox.widget.textclock,
        format = "%H:%M",
        font = beautiful.bar_font,
    })

    local widget = wibox.widget({
        icons.clock.widget(),
        clock,
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.bar_icon_text_spacing,
    })

    return widget
end


return create