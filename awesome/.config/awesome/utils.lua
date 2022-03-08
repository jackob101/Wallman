local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local awful = require("awful")

local M = {}

function M.create_stylesheet(class_name)
	return "." .. class_name .. "{color: " .. beautiful.fg_normal .. ";}"
end

function M.create_widget_with_icon(image, class_name, widget)
	return wibox.widget({
		{
			{
				stylesheet = M.create_stylesheet(class_name),
				image = image,
				widget = wibox.widget.imagebox,
			},
			right = 4,
			left = 4,
			widget = wibox.container.margin,
		},
		widget,
		layout = wibox.layout.align.horizontal,
	})
end

function M.draw_box(content, width, height)
	local box = wibox.widget({
		{

			{
				content,
				margins = beautiful.dashboard_margin,
				widget = wibox.container.margin,
			},
			valign = "center",
			halign = "center",
			widget = wibox.container.place,
		},
		widget = wibox.container.background,
		forced_width = width,
		forced_height = height,
		border_width = beautiful.dashboard_border_width,
		border_color = beautiful.dashboard_border_color,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(5))
		end,
		bg = beautiful.bg_normal,
	})

	return box
end

function M.generate_tooltip(target, text)
	awful.tooltip({
		objects = { target },
		text = text,
		bg = beautiful.tooltip_bg,
		margins = beautiful.tooltip_margins,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(2))
		end,
	})
end

function M.hover_effect(self)
	local old_cursor, old_wibox
	self:connect_signal("mouse::enter", function()
		if self.bg ~= beautiful.bg_hover then
			self.backup = self.bg
			self.has_backup = true
		end
		self.bg = beautiful.bg_hover
		local w = mouse.current_wibox
		old_cursor, old_wibox = w.cursor, w
		w.cursor = "hand1"
	end)
	self:connect_signal("mouse::leave", function()
		if self.has_backup then
			self.bg = self.backup
		end
		if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
		end
	end)
end

return M
