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

local function widget_create_callback(self, t, index)
	if t.icon_widget then
		local icon
		if t.selected then
			icon = t.icon_widget(beautiful.bg_normal)
		else
			icon = t.icon_widget(beautiful.fg_normal)
		end

		if icon then
			self:get_children_by_id("icon")[1]:add(icon)
		end

		if t.only_icon then
			self:get_children_by_id("text_role")[1].visible = false
		end
	end
	utils.cursor_hover(self)
end

local function widget_update_callback(self, t)
	if #self:get_children_by_id("icon")[1].children > 0 then
		if (t.selected or t.urgent) and t.only_icon then
			self:get_children_by_id("icon")[1].children[1].stylesheet = "*{fill: "
				.. beautiful.taglist_fg_focus
				.. " ;}"
		else
			self:get_children_by_id("icon")[1].children[1].stylesheet = "*{fill: " .. beautiful.fg_normal .. " ;}"
		end
	end
end

function M.initTagList(s)
	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.noempty,
		widget_template = {
			{
				{
					{
						{
							{
								widget = wibox.widget.textbox,
								id = "text_role",
								align = "center",
							},
							layout = wibox.layout.flex.vertical,
						},
						{
							{
								{
									id = "icon",
									layout = wibox.layout.fixed.horizontal,
								},
								widget = wibox.container.place,
								valign = "center",
								halign = "center",
							},
							widget = wibox.container.margin,
							margins = dpi(7),
						},
						layout = wibox.layout.stack,
					},
					layout = wibox.layout.flex.vertical,
				},
				widget = wibox.container.margin,
				left = dpi(5),
				right = dpi(5),
			},
			widget = wibox.container.background,
			id = "background_role",
			forced_width = beautiful.bar_height * 1.2,
			create_callback = widget_create_callback,
			update_callback = widget_update_callback,
		},
		buttons = taglist_buttons,
	})
end

return M
