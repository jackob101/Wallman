local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local styles = {}

styles.month = {
	padding = 5,
	bg_color = beautiful.transparent,
}

styles.normal = {
	fg_color = beautiful.fg_normal,
	bg_color = beautiful.transparent,
}

styles.focus = {
	fg_color = beautiful.color10,
	bg_color = beautiful.transparent,
	markup = function(t)
		return "<b>" .. t .. "</b>"
	end,
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, dpi(4))
	end,
}

styles.header = {
	fg_color = beautiful.fg_normal,
	bg_color = beautiful.transparent,
	markup = function(t)
		return "<b>" .. t .. "</b>"
	end,
}

styles.weekday = {
	fg_color = beautiful.fg_normal,
	bg_color = beautiful.transparent,
	markup = function(t)
		return "<b>" .. t .. "</b>"
	end,
}

local decorate_cell = function(widget, flag, date)
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end
	local props = styles[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d = { year = date.year, month = (date.month or 1), day = (date.day or 1) }
	local weekday = tonumber(os.date("%w", os.time(d)))
	local default_bg = (weekday == 0 or weekday == 6) and "#232323" or "#383838"
	local ret = wibox.widget({
		{
			widget,
			margins = (props.padding or 2) + (props.border_width or 0),
			widget = wibox.container.margin,
		},
		shape = props.shape,
		shape_border_color = props.border_color or "#b9214f",
		shape_border_width = props.border_width or 0,
		fg = props.fg_color or "#999999",
		bg = props.bg_color or default_bg,
		widget = wibox.container.background,
	})
	return ret
end

local calendar = wibox.widget({
	font = "Inter Regular 12",
	date = os.date("*t"),
	spacing = dpi(10),
	start_sunday = false,
	long_weekdays = false,
	fn_embed = decorate_cell,
	widget = wibox.widget.calendar.month,
})

local current_month = calendar:get_date().month

local update_focus_bg = function(month)
	if current_month == month then
		styles.focus.bg_color = beautiful.accent
		styles.focus.markup = function(t)
			return "<b>" .. t .. "</b>"
		end
	else
		styles.focus.bg_color = beautiful.transparent
		styles.focus.markup = function(t)
			return t
		end
	end
end

local update_active_month = function(i)
	local date = calendar:get_date()
	date.month = date.month + i
	update_focus_bg(date.month)
	calendar:set_date(nil)
	calendar:set_date(date)
end

calendar:buttons(gears.table.join(
	awful.button({}, 4, function()
		update_active_month(-1)
	end),
	awful.button({}, 5, function()
		update_active_month(1)
	end)
))

local widget = wibox.widget({
	{
		nil,
		calendar,
		top = dpi(15),
		right = dpi(10),
		left = dpi(10),
		widget = wibox.container.margin,
		layout = wibox.layout.align.horizontal,
		expand = "outside",
	},
	-- bg = beautiful.bg_overlay_transparent,
	widget = wibox.container.background,
})

return widget
