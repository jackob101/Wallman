#!/bin/lua

style = os.getenv("HOME") .. "/.config/rofi/powermenu/style.rasi"
uptime = io.popen("uptime -p | sed -e 's/up //g'"):read("*a")
host = io.popen("hostname"):read("*a")

hibernate = ''
shutdown = ''
reboot = ''
lock = ''
suspend = ''
logout = ''
yes = ''
no = ''

rofi_cmd = [[
    rofi -dmenu
		-p ' $USER@$host'
		-mesg ' Uptime:  .. uptime ..
    -theme  .. style
]]

print(rofi_cmd)
