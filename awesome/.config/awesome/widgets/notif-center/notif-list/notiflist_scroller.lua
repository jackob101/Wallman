local awful = require("awful")
local gears = require("gears")

local pointer = 1
local size = 7

local function get_pointer()
	return pointer
end

local function set_pointer(new)
	pointer = new
end

local add_button_event = function(widget)
	widget:buttons(gears.table.join(
		awful.button({}, 5, nil, function()
			if #widget.children > size and (#widget.children - pointer) >= size then
				widget.children[pointer].visible = false
				pointer = pointer + 1
				widget.children[pointer + size - 1].visible = true
			end
		end),
		awful.button({}, 4, nil, function()
			if pointer > 1 then
				widget.children[pointer + size - 1].visible = false
				pointer = pointer - 1
				widget.children[pointer].visible = true
			end
		end)
	))
end

return {
	pointer = get_pointer,
	set_pointer = set_pointer,
	size = size,
	add_button_events = add_button_event,
}
