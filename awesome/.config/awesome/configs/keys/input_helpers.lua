local M = {}

local function press_button(button)
	root.fake_input("key_press", button)
	root.fake_input("key_release", button)
end

M.pop_flasks = function()
	press_button("2")
	press_button("3")
	press_button("4")
	press_button("5")
end

function M.mouse_button_press(button_id, _, _)
	root.fake_input("button_press", button_id)
	root.fake_input("button_release", button_id)
end

return M
