local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")
local icons = require("icons")


local posture = gears.timer {
  timeout = 1800,
  autostart = true,
  call_now = true,
  callback = function()
    naughty.notification {
      title = "Posture check",
      message = "Are you sitting properly?",
      icon = icons.posture,
      urgency = "normal",
    }
  end
}

posture:start()
