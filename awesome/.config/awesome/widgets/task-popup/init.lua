local awful = require("awful")
local icons = require("icons")

local menu = {}

local M = {}
function M.create(c)
	menu = awful.menu({
		{
			"Some name",
			function()
				print("hello from menu")
			end,
			icons.window_minimize,
		},
	})
end

function M.show()
	menu:show()
	mousegrabber.run(function(m)
		if m.buttons[1] or m.buttons[3] then
			menu:hide()
			return false
		end
    return true
	end, "left_ptr")
  print("After grabber") 
end

return M
