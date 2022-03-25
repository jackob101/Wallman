local awful = require("awful")

awful.layout.remove_default_layout()
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.append_default_layouts({
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
})
-- }}}
