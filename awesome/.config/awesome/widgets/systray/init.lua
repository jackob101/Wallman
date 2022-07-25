local wibox = require("wibox")

function create(s)
    return wibox.widget({
        widget = wibox.widget.systray,
        screen = "primary",
    })
end

return create