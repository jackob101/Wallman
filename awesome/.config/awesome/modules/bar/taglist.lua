local awful = require("awful")
local gears = require("gears")
local modkey = require("configs.keys.mod").modkey
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")

local M = {}

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local function widget_create_callback(self)
	utils.hover_effect(self)
	self:connect_signal("button::press", function()
		self.backup = beautiful.taglist_bg_focus
	end)
end

function M.initTagList(s)
	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.noempty,
		widget_template = {
			{
				widget = wibox.widget.textbox,
				id = "text_role",
				align = "center",
			},
			widget = wibox.container.background,
			id = "background_role",
			forced_width = beautiful.bar_height,
			create_callback = widget_create_callback,
		},
		buttons = taglist_buttons,
	})
end

return M
