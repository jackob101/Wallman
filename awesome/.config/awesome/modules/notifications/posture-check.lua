local naughty = require("naughty")
local gears = require("gears")
local icons = require("icons")

local configured = false

local function posture_callback()
	if configured then
		naughty.notification({
			title = "Posture check",
			message = "Are you sitting properly?",
			icon = icons.posture,
			urgency = "normal",
      store = false,
		})
	end
end

local posture = gears.timer({
	timeout = 1800,
	autostart = true,
	call_now = true,
	callback = posture_callback,
})

if not posture.started then
	posture:start()
end

configured = true
