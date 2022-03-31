local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")

local profile_imagebox = wibox.widget({
	id = "icon",
	forced_height = dpi(60),
	forced_width = dpi(60),
	image = icons.default,
	widget = wibox.widget.imagebox,
	resize = true,
})

local profile_name = wibox.widget({
	font = "Inter Regular 10",
	markup = "User",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local distro_name = wibox.widget({
	font = "Inter Regular 10",
	markup = "GNU/Linux",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local kernel_version = wibox.widget({
	font = "Inter Regular 10",
	markup = "Linux",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local uptime_time = wibox.widget({
	font = "Inter Regular 10",
	markup = "up 1 minute",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

awful.spawn.easy_async_with_shell(
	[[
	sh -c '
	fullname="$(getent passwd `whoami` | cut -d ':' -f 5 | cut -d ',' -f 1 | tr -d "\n")"
	if [ -z "$fullname" ];
	then
		printf "$(whoami)@$(hostname)"
	else
		printf "$fullname"
	fi
	'
	]],
	function(stdout)
		local stdout = stdout:gsub("%\n", "")
		profile_name:set_markup(stdout)
	end
)

awful.spawn.easy_async_with_shell(
	[[
	cat /etc/os-release | awk 'NR==1'| awk -F '"' '{print $2}'
	]],
	function(stdout)
		local distroname = stdout:gsub("%\n", "")
		distro_name:set_markup(distroname)
	end
)

awful.spawn.easy_async_with_shell("uname -r", function(stdout)
	local kname = stdout:gsub("%\n", "")
	kernel_version:set_markup(kname)
end)

local update_uptime = function()
	awful.spawn.easy_async_with_shell("uptime -p", function(stdout)
		local uptime = stdout:gsub("%\n", "")
		uptime_time:set_markup(uptime)
	end)
end

local uptime_updater_timer = gears.timer({
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function()
		update_uptime()
	end,
})

local user_profile = wibox.widget({
	{
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			{
				layout = wibox.layout.align.vertical,
				expand = "none",
				nil,
				profile_imagebox,
				nil,
			},
			{
				layout = wibox.layout.align.vertical,
				expand = "none",
				nil,
				{
					layout = wibox.layout.fixed.vertical,
					profile_name,
					distro_name,
					kernel_version,
					uptime_time,
				},
				nil,
			},
		},
		margins = dpi(10),
		widget = wibox.container.margin,
	},
	forced_height = dpi(92),
	-- bg = beautiful.bg_overlay_transparent,
	widget = wibox.container.background,
})

user_profile:connect_signal("mouse::enter", function()
	update_uptime()
end)

return user_profile
