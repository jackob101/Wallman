local dir = os.getenv("HOME") .. "/.config/awesome/icons/"
local wibox = require("wibox")
local beautiful = require("beautiful")

--- @class IconsHandler : Initializable
--- @field icons Icon[]
IconsHandler = {}

function IconsHandler.init()


	--- @field clock Icon
	IconsHandler.icons = {
		clock = IconsHandler.addIcon("clock.svg"),
		power = IconsHandler.addIcon( "power.svg"),
		restart = IconsHandler.addIcon( "restart.svg"),
		sleep = IconsHandler.addIcon( "power-sleep.svg"),
		logout = IconsHandler.addIcon( "logout.svg"),
		default = IconsHandler.addIcon( "account.png"),
		lock = IconsHandler.addIcon( "lock.svg"),
		volume = IconsHandler.addIcon( "volume.svg"),
		posture = IconsHandler.addIcon( "heart.svg"),
		logo = IconsHandler.addIcon( "arch.svg"),
		clock = IconsHandler.addIcon("clock.svg"),
		keyboard = IconsHandler.addIcon( "keyboard.svg"),
		macros = IconsHandler.addIcon( "macro.svg"),
		bell = IconsHandler.addIcon( "bell.svg"),
		bell_slash = IconsHandler.addIcon( "bell-slash.svg"),
		calendar = IconsHandler.addIcon("calendar.svg"),
		volume_high = IconsHandler.addIcon( "volume-high.svg"),
		volume_medium = IconsHandler.addIcon( "volume-medium.svg"),
		volume_low = IconsHandler.addIcon( "volume-low.svg"),
		volume_mute = IconsHandler.addIcon( "volume-mute.svg"),
		window_minimize = IconsHandler.addIcon("window-minimize.svg"),
		window_maximize = IconsHandler.addIcon("window-maximize.svg"),
		window_expand = IconsHandler.addIcon( "expand.svg"),
		window_fullscreen = IconsHandler.addIcon( "fullscreen.svg"),
		window_close = IconsHandler.addIcon("close.svg"),
		list_clear = IconsHandler.addIcon("list-clear.svg"),
		planet = IconsHandler.addIcon("planet.svg"),
		terminal = IconsHandler.addIcon("terminal.svg"),
		code_tags = IconsHandler.addIcon("code-tags.svg"),
		telegram = IconsHandler.addIcon("telegram.svg"),
		discord = IconsHandler.addIcon("discord.svg"),
		circle = IconsHandler.addIcon("circle.svg"),
		spotify = IconsHandler.addIcon("spotify.svg"),
		notification_center_open = IconsHandler.addIcon( "notification-center-open.svg"),
		notification_center_close = IconsHandler.addIcon( "notification-center-close.svg"),
	}


end

--- @return Icon
function IconsHandler.addIcon(fileName)
	return {
		widget = function(color)
			local icon_color = color or Beautiful.fg_normal
			local stylesheet = "*{fill: " .. icon_color .. " ;}"
			return Wibox.widget({
				widget = Wibox.widget.imagebox,
				image = dir .. fileName,
				stylesheet = stylesheet,
			})
		end,
		path = dir .. fileName,
	}
end

