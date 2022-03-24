local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local awful = require("awful")
local icons = require("icons")
local utils = require("utils")

local notif_core = require("widgets.notif-center.notif-list")

local stylesheet = "*{fill: " .. beautiful.fg_normal .. "; }"

local clear_all_text = wibox.widget({
	icons.list_clear.widget(),
	widget = wibox.container.background,
	forced_width = dpi(18),
	forced_height = dpi(18),
})

local button = wibox.widget({
	{
		clear_all_text,
		widget = wibox.container.margin,
		margins = dpi(8),
	},
	widget = wibox.container.background,
	bg = beautiful.bg_overlay_transparent,
	shape = gears.shape.circle,
})

utils.generate_tooltip(button, "Clear all notifications")
utils.cursor_hover(button)
utils.background_hover(button)

button:buttons(gears.table.join(awful.button({}, 1, nil, function()
	notif_core.reset_list()
end)))

return button
