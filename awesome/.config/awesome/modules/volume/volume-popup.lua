local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local volume_header = wibox.widget({
	text = "Volume",
	font = "Ubuntu 12",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local volume_value = wibox.widget({
	text = "0%",
	font = "Ubuntu 12",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local volume_slider_widget = wibox.widget({
	nil,
	{
		id = "volume_slider",
		bar_shape = gears.shape.rounded_rect,
		bar_height = dpi(4),
		bar_color = beautiful.fg_normal .. "AA",
		bar_active_color = beautiful.fg_normal,
		handle_color = beautiful.bg_focus,
		handle_shape = gears.shape.circle,
		handle_width = dpi(20),
		handle_border_color = "#00000012",
		handle_border_width = dpi(1),
		maximum = 100,
		widget = wibox.widget.slider,
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical,
})

local volume_slider = volume_slider_widget.volume_slider

local update_widget = function()
	awful.spawn.easy_async_with_shell([[bash -c "amixer -D pulse sget Master"]], function(stdout)
		local volume = string.match(stdout, "(%d?%d?%d)%%")
		volume_slider:set_value(tonumber(volume))
		volume_value:set_text(volume .. "%")
	end)
end

update_widget()

awesome.connect_signal("module::volume:update", function()
	update_widget()
end)

local function start_timer(s)
	gears.timer({
		timeout = 2,
		autostart = true,
		single_shot = true,
		callback = function()
			s.volume_overlay.visible = false
			s.display_volume_widget = false
		end,
	})
end

local hide_widget = gears.timer({
	timeout = 2,
	autostart = true,
	single_shot = true,
	callback = function()
		local focused = awful.screen.focused()
		focused.volume_overlay.visible = false
		focused.display_volume_widget = false
	end,
})

local widget_height = dpi(100)
local widget_width = dpi(300)
local widget_margin = dpi(15)

screen.connect_signal("request::desktop_decoration", function(s)
	s.display_volume_widget = false

	s.volume_overlay = awful.popup({
		widget = {
			{
				{
					{
						layout = wibox.layout.align.horizontal,
						expand = "none",
						forced_height = dpi(48),
						volume_header,
						nil,
						volume_value,
					},
					volume_slider,
					layout = wibox.layout.fixed.vertical,
				},
				left = dpi(24),
				right = dpi(24),
				widget = wibox.container.margin,
			},
			bg = beautiful.background,
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background(),
		},
		ontop = true,
		visible = false,
		type = "notification",
		screen = s,
		height = widget_height,
		width = widget_width,
		maximum_height = widget_height,
		maximum_width = widget_width,
		offset = dpi(5),
		shape = gears.shape.rounded_rect,
		radius = dpi(5),
		bg = beautiful.transparent,
		preferred_anchors = "middle",
		preferred_positions = { "left", "right", "top", "bottom" },
	})

	s.volume_overlay:connect_signal("mouse::enter", function()
		hide_widget:stop()
	end)

	s.volume_overlay:connect_signal("mouse::leave", function()
		hide_widget:start()
	end)
end)

awesome.connect_signal("module::volume_widget:rerun", function()
	if hide_widget.started then
		hide_widget:again()
	else
		hide_widget:start()
	end
end)

awesome.connect_signal("module::volume:show", function(bool)
	awesome.emit_signal("module::volume:update")

	local focused = awful.screen.focused()
	local volume_overlay = focused.volume_overlay

	awful.placement.bottom_right(volume_overlay, {
		margins = {
			right = widget_margin,
			bottom = widget_margin,
			top = 0,
			left = 0,
		},
		honor_workarea = true,
	})

	volume_overlay.visible = bool

	if bool then
		awesome.emit_signal("module::volume_widget:rerun")
	else
		if hide_widget.started then
			hide_widget:stop()
		end
	end
end)
