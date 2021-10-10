local awful = require("awful")

applications = {
	"telegram-desktop",
	"discord",
	"picom --experimental-backends --config ~/.config/picom/config",
	"flameshot",
}

for app = 1, #applications do
	awful.spawn.easy_async_with_shell(applications[app])
end
