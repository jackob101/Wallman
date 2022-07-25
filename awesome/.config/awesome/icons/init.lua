local dir = os.getenv("HOME") .. "/.config/awesome/icons/"
local wibox = require("wibox")
local beautiful = require("beautiful")

local function prepare_icon(name)
	return {
		widget = function(color)
			local icon_color = color or beautiful.fg_normal
			local stylesheet = "*{fill: " .. icon_color .. " ;}"
			return wibox.widget({
				widget = wibox.widget.imagebox,
				image = dir .. name,
				stylesheet = stylesheet,
			})
		end,
		raw_icon = dir .. name,
	}
end

return {
	power = dir .. "power.svg",
	restart = dir .. "restart.svg",
	sleep = dir .. "power-sleep.svg",
	logout = dir .. "logout.svg",
	default = dir .. "account.png",
	lock = dir .. "lock.svg",
	volume = dir .. "volume.svg",
	posture = dir .. "heart.svg",
	logo = dir .. "arch.svg",
	clock = prepare_icon("clock.svg"),
	keyboard = dir .. "keyboard.svg",
	macros = dir .. "macro.svg",
	bell = dir .. "bell.svg",
	bell_slash = dir .. "bell-slash.svg",
	calendar = prepare_icon("calendar.svg"),
	volume_high = dir .. "volume-high.svg",
	volume_medium = dir .. "volume-medium.svg",
	volume_low = dir .. "volume-low.svg",
	volume_mute = dir .. "volume-mute.svg",
	window_minimize = prepare_icon("window-minimize.svg"),
	window_maximize = prepare_icon("window-maximize.svg"),
	window_expand = dir .. "expand.svg",
	window_fullscreen = dir .. "fullscreen.svg",
	window_close = prepare_icon("close.svg"),
	list_clear = prepare_icon("list-clear.svg"),
	planet = prepare_icon("planet.svg"),
	terminal = prepare_icon("terminal.svg"),
	code_tags = prepare_icon("code-tags.svg"),
	telegram = prepare_icon("telegram.svg"),
	discord = prepare_icon("discord.svg"),
	circle = prepare_icon("circle.svg"),
	spotify = prepare_icon("spotify.svg"),
	notification_center_open = dir .. "notification-center-open.svg",
	notification_center_close = dir .. "notification-center-close.svg",
}
