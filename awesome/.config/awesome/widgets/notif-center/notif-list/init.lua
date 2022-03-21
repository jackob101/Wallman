local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")

local notiflist_scroller = require("widgets.notif-center.notif-list.notiflist_scroller")
local empty_list = require("widgets.notif-center.notif-list.empty_list_widget")

local notif_core = {}

notif_core.empty_list = true

notif_core.counter = nil

notif_core.notiflist_layout = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(7),
	empty_list,
})

notiflist_scroller(notif_core.notiflist_layout)

notif_core.update = function()
	-- Update counter value
	if notif_core.counter then
		if notif_core.empty_list then
			notif_core.counter.text = "(0)"
		else
			notif_core.counter.text = "(" .. #notif_core.notiflist_layout.children .. ")"
		end
	end
end

notif_core.reset_list = function()
	notif_core.notiflist_layout:reset()
	notif_core.empty_list = true
	notif_core.notiflist_layout:insert(1, empty_list)
	notif_core.update()
end

local function add_notification(n)
	if #notif_core.notiflist_layout.children == 1 and notif_core.empty_list then
		notif_core.notiflist_layout:reset()
		notif_core.empty_list = false
	end

	local notif_creator = require("widgets.notif-center.notif-list.notif_creator")
	local new_notif = notif_creator(n)
	notif_core.notiflist_layout:insert(1, new_notif)
end

local notifbox_add_expired = function(n)
	n:connect_signal("destroyed", function(_, reason)
		if reason == 1 then
			add_notification(n)
			notif_core.update()
		end
	end)
end

naughty.connect_signal("request::display", function(n)
	if n._private.args.store == nil or n._private.args.store then
		notifbox_add_expired(n)
	end
end)

notif_core.connect_count = function(counter)
	notif_core.counter = counter
end

return notif_core
