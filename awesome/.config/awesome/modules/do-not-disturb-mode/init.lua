local naughty = require("naughty")
local icons = require("icons")

local is_dnd_on = false

awesome.connect_signal("modules::dnd:toggle", function()
	is_dnd_on = not is_dnd_on

	if is_dnd_on then
		naughty.notification({
			title = "Do not disturb",
			message = "Do not disturb has been turned on",
      icon = icons.bell_slash,
		})
	end

	awesome.emit_signal("modules::dnd:changed", is_dnd_on)

	if not is_dnd_on then
		naughty.notification({
			title = "Do not disturb",
			message = "Do not disturb has been turned off",
      icon = icons.bell,
		})
	end
end)
