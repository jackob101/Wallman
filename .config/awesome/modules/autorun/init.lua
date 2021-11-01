local awful = require("awful")

applications = {
	"picom --experimental-backends --config ~/.config/picom/config",
        "conky -c $HOME/.config/conky/goals.conkyrc"
}

runOnce = {
	"discord",
	"telegram-desktop",
	"flameshot",
}

for app = 1, #runOnce do
	awful.spawn(runOnce[app], { urgent = false })
end

for app = 1, #applications do
	awful.spawn.easy_async_with_shell(applications[app], { urgent = false })
end
