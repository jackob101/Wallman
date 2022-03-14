local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function create(items)
	local popup = awful.popup({
		ontop = true,
		visible = false,
		maximum_width = 400,
		widget = {},
    border_width = 1,
    border_color = beautiful.border_focus,
		bg = beautiful.bg_overlay,
	})

	local rows = { layout = wibox.layout.fixed.vertical }
	local stylesheet = "#image{fill: " .. beautiful.menu_icon_color .. ";}"

	for _, item in ipairs(items) do
		local row = wibox.widget({
			{
				{
					{
						widget = wibox.widget.imagebox,
						image = item.icon,
						forced_width = beautiful.menu_icon_size,
						forced_height = beautiful.menu_icon_size,
						stylesheet = stylesheet,
					},
					{
						text = item.name,
						widget = wibox.widget.textbox,
					},
					spacing = 12,
					layout = wibox.layout.fixed.horizontal,
				},
				widget = wibox.container.margin,
				margins = 8,
			},
			widget = wibox.container.background,
		})

		local old_cursor, old_wibox
		row:connect_signal("mouse::enter", function(c)
			c:set_bg(beautiful.bg_focus)

			local wb = mouse.current_wibox
			old_cursor, old_wibox = wb.cursor, wb
			wb.cursor = "hand1"
		end)
		row:connect_signal("mouse::leave", function(c)
			c:set_bg(beautiful.bg_overlay)

			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end)

		row:buttons(awful.util.table.join(awful.button({}, 1, function()
			item.onclick()
		end)))
		table.insert(rows, row)
	end

	popup:setup(rows)

	-- local menu = awful.menu(items)
	popup:connect_signal("mouse::leave", function()
		popup.visible = false
	end)

	-- return menu
	return popup
end

return create
