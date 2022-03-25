local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
-- local calendar_popup = require("modules.bar.calendar")
local utils = require("utils")
local icons = require("icons")

local function create(s)
	local clock = wibox.widget({
		widget = wibox.widget.textclock,
		format = "%H:%M",
		font = beautiful.bar_font,
	})

	local calendar = wibox.widget({
		widget = wibox.widget.textclock,
		format = "%a %b %d",
		font = beautiful.bar_font,
	})

	s.time_date = wibox.widget({
		{
			{
				icons.clock.widget(),
				clock,
				layout = wibox.layout.fixed.horizontal,
				spacing = beautiful.bar_icon_text_spacing,
			},
			{
				icons.calendar.widget(),
				calendar,
				layout = wibox.layout.fixed.horizontal,
				spacing = beautiful.bar_icon_text_spacing,
			},
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
	})

	-- local callendar_widget = calendar_popup({
	-- 	theme = "naughty",
	-- 	placement = "bottom_right",
	-- 	radius = 0,
	-- })

	-- s.time_date:connect_signal("button::press", function(_, _, _, button)
	-- 	if button == 1 then
	-- 		callendar_widget.toggle()
	-- 	end
	-- end)

	utils.cursor_hover(s.time_date)

	return s.time_date
end

return create
