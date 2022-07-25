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
	return awful.tooltip({
		objects = { target },
		text = text,
		bg = beautiful.tooltip_bg,
    mode = "outside",
		margins = beautiful.tooltip_margins,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(2))
		end,
    gaps = dpi(5),
	})
end

function M.cursor_hover(widget)
	local old_cursor, old_wibox
	widget:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			old_cursor, old_wibox = w.cursor, w
			w.cursor = "hand1"
		end
	end)

	widget:connect_signal("mouse::leave", function()
		if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
		end
	end)
end

function M.background_hover(widget)
	widget:connect_signal("mouse::enter", function()
		if widget.bg ~= beautiful.bg_hover then
			widget.backup = widget.bg
			widget.has_backup = true
		end
		widget.bg = beautiful.bg_hover
	end)
	widget:connect_signal("mouse::leave", function()
		if widget.has_backup then
			widget.bg = widget.backup
		end
	end)
end

function M.hover_effect(widget)
	M.cursor_hover(widget)
	M.background_hover(widget)
end

-- Global utils
function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end
return M
