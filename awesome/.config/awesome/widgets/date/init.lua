local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("icons")

local function create()
    local calendar = wibox.widget({
        widget = wibox.widget.textclock,
        format = "%a %b %d",
        font = beautiful.bar_font,
    })

    local widget = wibox.widget({
        icons.calendar.widget(),
        calendar,
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.bar_icon_text_spacing,
    })

    return widget
end

return create

