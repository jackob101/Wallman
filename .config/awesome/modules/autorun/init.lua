local awful = require("awful")

applications = {
	"picom --experimental-backends --config ~/.config/picom/config",
	"easyeffects -l Bass Boosted --gapplication-service",
	"xset r rate 200 20",
	"aw-server",
	"aw-watcher-afk",
	"aw-watcher-window",
	"discord",
	"telegram-desktop",
	"flameshot",
}

for app = 1, #applications do
	awful.spawn.easy_async_with_shell(applications[app], function() end)
end
