local gears = require("gears")
local awful = require("awful")

----------------------------------------
-- TODO Add popup window that displays all layouts after left click
----------------------------------------

local function create(s)
	local layoutbox = awful.widget.layoutbox(s)
	layoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	return layoutbox
end

return create
