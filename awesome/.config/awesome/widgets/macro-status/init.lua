local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")

local widget = wibox.widget({
	{
		text = "Macro on",
		widget = wibox.widget.textbox,
	},
	fg = beautiful.accent3,
	widget = wibox.container.background,
	visible = false,
})

utils.generate_tooltip(widget, "Click to turn off")

local update_widget = function(v)
	widget.visible = v
end

widget:connect_signal("button::release", function()
	awesome.emit_signal("macros::toggle")
end)

awesome.connect_signal("macros::update", update_widget)

return widget
