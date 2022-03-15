local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local text = wibox.widget({
	widget = wibox.widget.textbox,
	valign = "center",
	halign = "left",
	text = "Notification center",
	font = "Inter bold 16",
})

local count = wibox.widget({
	widget = wibox.widget.textbox,
	valign = "center",
	text = "(0)",
	font = "Inter bold 16",
})


return {
  counter = count,
  text = text,
  widget = wibox.widget{
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(10),
    text,
    count,
  }
}
