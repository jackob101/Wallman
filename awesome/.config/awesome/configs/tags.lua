local awful = require("awful")

screen.connect_signal("request::desktop_decoration", function(s)
    Awful.tag(
            { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
            s,
            Awful.layout.layouts[1]
    )
end)
