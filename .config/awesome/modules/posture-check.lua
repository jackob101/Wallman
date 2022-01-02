local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")
local icons = require("icons")


local posture = gears.timer {
  timeout = 1800,
  autostart = true,
  call_now = true,
  urgency = "critical",
  callback = function()
    naughty.notification {
      title = "Posture check",
      message = "Can you sit correctly you fat fuk",
      icon = icons.posture,
      icon_size = 200,
      margin = 15,
    }
  end
}

posture:start()
