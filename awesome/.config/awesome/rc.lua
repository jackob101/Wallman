-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local menubar = require("menubar")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

require("configs")

require("layout")

require("errors.startupHandling")

require("modules.notifications.notificationConfig")
require("modules.volume")
require("modules.top-bar")
require("modules.exit-screen")
require("modules.volume.volume-popup")
require("modules.notifications.posture-check")
require("modules.dashboard")
require("modules.notification-center")
require("modules.do-not-disturb-mode")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

require("modules.autorun.init")
