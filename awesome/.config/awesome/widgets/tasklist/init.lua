local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local utils = require("utils")
local beautiful = require("beautiful")
local icons = require("icons")

local M = {}

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 2, function(c)
		c:kill()
	end),
	awful.button({}, 3, function(c)
		if c.popup.visible then
			c.popup.visible = not c.popup.visible
		else
			c.popup:move_next_to(mouse.current_widget_geometry)
		end
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function widget_create_callback(self, c, index)
	utils.hover_effect(self)
	utils.generate_tooltip(self, c.class)

	local menu_items = {
		{
			name = "Minimize",
			onclick = function()
				c.minimized = not c.minimized
			end,
			icon = icons.window_minimize,
		},
		{
			name = "Maximize",
			onclick = function()
				c.maximized = not c.maximized
			end,
			icon = icons.window_maximize,
		},
		{
			name = "Fullscreen",
			onclick = function()
				c.fullscreen = not c.fullscreen
			end,
			icon = icons.window_fullscreen,
		},
		{
			name = "Kill client",
			onclick = function()
				c:kill()
			end,
			icon = icons.window_close,
		},
	}
	c.popup = require("widgets.menu")(menu_items)
	c.popup.offset = { x = 40 }
end

function M.initTaskList(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		layout = {
			spacing = dpi(5),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				nil,
				{
					{
						id = "icon_role",
						widget = wibox.widget.imagebox,
						scaling_quility = "good",
					},
					widget = wibox.container.margin,
					margins = dpi(5),
				},
				layout = wibox.layout.align.horizontal,
				expand = "outside",
			},
			widget = wibox.container.background,
			create_callback = widget_create_callback,
			forced_width = beautiful.bar_height * 1.5,
		},
		buttons = tasklist_buttons,
	})
end

return M
