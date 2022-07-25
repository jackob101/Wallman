local awful = require("awful")

awful.layout.remove_default_layout()
awful.layout.append_default_layouts({
	awful.layout.suit.tile,
	awful.layout.suit.floating,
})
