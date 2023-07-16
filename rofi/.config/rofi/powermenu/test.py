#!/bin/python3

import os
import subprocess

style = os.environ["HOME"]
uptime = os.popen("uptime -p | sed -e 's/up //g'").read().strip()

hibernate = " Hibernate"
shutdown = " Shutdown"
reboot = " Reboot"
lock = " Lock"
suspend = " Suspend"
logout = " Logout"
yes = " yes"
no = " No"

rofi_cmd = """rofi -i -dmenu 
		-p ' $USER@$host'
		-mesg ' Uptime: {}
        -theme {}""".format(
    uptime, style
)

rofi_params = "{}\n{}\n{}\n{}\n{}\n{}".format(
    shutdown, reboot, lock, suspend, hibernate, logout
)

response = os.popen("echo -e '{}' | {}".format(rofi_params, rofi_cmd)).read()
