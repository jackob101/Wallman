-- Global variables

ModKey = "Mod4"


-- Global Modules

--- @type Beautiful
Beautiful = require("beautiful")

--- @type Gears
Gears = require("gears")

--- @type Wibox
Wibox = require("wibox")

--- @type Awful
Awful = require("awful")

--- @type Naughty
Naughty = require("naughty")

--- @type Ruled
Ruled = require("ruled")

--- @type Menubar
Menubar = require("menubar")

--- @type Dpi
Dpi = Beautiful.xresources.apply_dpi

Beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

