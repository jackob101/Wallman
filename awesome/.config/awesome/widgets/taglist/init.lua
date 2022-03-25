local awful = require("awful")
local gears = require("gears")
local modkey = require("configs.keys.mod").modkey
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")
local dpi = beautiful.xresources.apply_dpi

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

-- TODO Temporary colors
local function add_icon_hover(widget, icon)
	widget:connect_signal("mouse::enter", function()
		icon.stylesheet = "*{fill: #FFFFFF ;}"
	end)
	widget:connect_signal("mouse::leave", function()
		icon.stylesheet = "*{fill: " .. beautiful.fg_normal .. " ;}"
	end)
end

local function widget_create_callback(self, t, index)
	if t.icon_widget then
		local icon = t.icon_widget(beautiful.fg_normal)
		self:get_children_by_id("icon")[1]:add(icon)
		add_icon_hover(self, icon)
		if t.only_icon then
			self:get_children_by_id("text_role")[1].visible = false
		end
	end
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
				{
					{
						widget = wibox.widget.textbox,
						id = "text_role",
						align = "center",
					},
					{
						{
							id = "icon",
							layout = wibox.layout.fixed.horizontal,
							widget = wibox.container.background,
						},
						widget = wibox.container.margin,
						margins = dpi(9),
					},
					layout = wibox.layout.stack,
				},
				widget = wibox.container.margin,
				left = dpi(5),
				right = dpi(5),
			},
			{
				layout = wibox.layout.align.vertical,
				expand = "inside",
				nil,
				nil,
				{
					widget = wibox.container.background,
					-- shape = function(cr, width, height)
					-- 	return gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false)
					-- end,
					shape = function(cr, width, height)
						return gears.shape.transform(gears.shape.circle):scale(4, 4)(cr, width / 4, height)
					end,
					{
						widget = wibox.container.background,
						id = "background_role",
					},
					forced_height = dpi(7),
				},
			},
			layout = wibox.layout.stack,
			-- forced_width = beautiful.bar_height,
			create_callback = widget_create_callback,
		},
		buttons = taglist_buttons,
	})
end

return M
