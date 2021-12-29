local awful = require("awful")

applications = {
	"sh -c picom --experimental-backends --config ~/.config/picom/config",
	"sh -c 'emacs --daemon'",
    --"conky -c $HOME/.config/conky/goals.conkyrc",
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
	awful.spawn.once(applications[app], { urgent = false })
end
