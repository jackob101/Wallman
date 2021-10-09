local awful = require("awful")

applications = {
	"telegram-desktop",
	"discord",
}

for app = 1, #applications do
	awful.util.spawn(applications[app])
end
