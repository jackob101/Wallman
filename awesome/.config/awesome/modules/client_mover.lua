local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local function start(c)
	local text_widget = wibox.widget({
		widget = wibox.widget.textbox,
		align = "center",
		font = "Inter bold 36",
	})

	text_widget.text = "Select screen [1-2]"

	local backdrop = awful.popup({
		screen = c.screen,
		visible = false,
		ontop = true,
		type = "dock",
		shape = gears.shape.rectangle,
		bg = beautiful.bg_normal .. "AA",
		width = c.screen.geometry.width,
		height = c.screen.geometry.height,
		minimum_width = c.screen.geometry.width,
		minimum_height = c.screen.geometry.height,
		widget = {
			widget = wibox.container.place,
			valign = "center",
			halign = "center",
			text_widget,
		},
	})

	local screen_index
	local tag_index

	if screen:count() == 2 then
		screen_index = (awful.screen.focused().index % 2) + 1
		text_widget.text = "Select tag [0-9]"
	end

	local function move()
		-- Move client to selected screen, tag and set correct focus
		if tag_index and screen_index then
			local s = screen[screen_index]
			c:move_to_screen(s)
			local tag = s.tags[tag_index]

			for _, t in ipairs(s.tags) do
				t.selected = false
			end

			c:move_to_tag(tag)
			tag.selected = true
		end
	end

	awful.keygrabber({
		autostart = true,
		start_callback = function()
			backdrop.visible = true
		end,
		stop_callback = function()
			backdrop.visible = false
			move()
		end,
		keypressed_callback = function(self, mod, key)
			if key == "Escape" then
				self:stop()
			end
			-- If screen index is set skip this step. It provides easier way to switch between two screens
			if screen_index == nil then
				local number = tonumber(key)
				-- Check if number is in range from 1 to screen amount
				if number and number > 0 and number <= screen:count() then
					screen_index = number
					text_widget.text = "Select tag [0-9]"
				else
					-- TODO Implement some error hanndling
					self:stop()
				end
			elseif screen_index ~= nil then
				local number = tonumber(key)
				if number and number >= 0 and number <= 9 then
					tag_index = number
				end
				self:stop()
			end
		end,
	})
end

return start
