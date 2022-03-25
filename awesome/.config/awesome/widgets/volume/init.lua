local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local icons = require("icons")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")

-- Widget declarationlocal icon_widget = wibox.widget({
local icon_widget = wibox.widget({
	resize = true,
	image = icons.volume_high,
	widget = wibox.widget.imagebox,
})

local text_widget = wibox.widget({
	text = "",
	widget = wibox.widget.textbox,
	font = beautiful.bar_font,
})

local widget = wibox.widget({
	{
		{
			icon_widget,
			widget = wibox.container.margin,
			margins = beautiful.bar_icon_margin,
		},
		text_widget,
		layout = wibox.layout.fixed.horizontal,
		spacing = beautiful.bar_icon_text_spacing,
	},
	widget = wibox.container.background,
})

local tooltip = utils.generate_tooltip(widget, "Click to mute")

local function generate_stylesheet(color)
	return "#image{fill: " .. beautiful.fg_normal .. ";}"
end

-- Main function to update widget
local function update()
	local function update_icon(volume)
		if type(volume) == "number" then
			if volume >= 75 then
				icon_widget.image = icons.volume_high
				icon_widget.stylesheet = generate_stylesheet(beautiful.accent1)
				widget.fg = beautiful.fg_normal
			elseif volume < 75 and volume >= 35 then
				icon_widget.image = icons.volume_medium
				icon_widget.stylesheet = generate_stylesheet(beautiful.accent2)
				widget.fg = beautiful.fg_normal
			else
				icon_widget.image = icons.volume_low
				icon_widget.stylesheet = generate_stylesheet(beautiful.accent6)
				widget.fg = beautiful.fg_normal
			end
		end
	end

	awful.spawn.easy_async("amixer -D pulse sget Master", function(out)
		local mute = string.match(out, "%[(o%D%D?)%]") -- \[(o\D\D?)\] - [on] or [off]
		local newVolume = string.match(out, "(%d?%d?%d)%%")

		if mute == "off" then
			icon_widget.image = icons.volume_mute
			tooltip.text = "Click to unmute"
			icon_widget.stylesheet = generate_stylesheet(beautiful.accent4)
			widget.fg = beautiful.fg_normal
			text_widget.text = "Muted"
		elseif mute == "on" then
			update_icon(tonumber(newVolume))
			tooltip.text = "Click to mute"
			text_widget.text = newVolume .. "%"
		end
	end)
end

-- Signals
awesome.connect_signal("module::volume::widgets:update", update)

widget:connect_signal("button::press", function(_, _, _, b)
	if b == 1 then
		awesome.emit_signal("module::volume:toggle")
	elseif b == 3 then
		awful.spawn("pavucontrol")
	elseif b == 4 then
		awesome.emit_signal("module::volume:up")
	elseif b == 5 then
		awesome.emit_signal("module::volume:down")
	end
end)

local old_cursor, old_wibox
widget:connect_signal("mouse::enter", function()
	local w = mouse.current_wibox
	old_cursor, old_wibox = w.cursor, w
	w.cursor = "hand1"
end)
widget:connect_signal("mouse::leave", function()
	if old_wibox then
		old_wibox.cursor = old_cursor
		old_wibox = nil
	end
end)

return widget
