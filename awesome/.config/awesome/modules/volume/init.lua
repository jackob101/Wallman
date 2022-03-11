local awful = require("awful")
local gears = require("gears")

local INC_VOLUME_CMD = "amixer -D pulse sset Master 5%+"
local DEC_VOLUME_CMD = "amixer -D pulse sset Master 5%-"
local TOG_VOLUME_CMD = "amixer -D pulse sset Master toggle"
local UPDATE_SIGNAL = "module::volume::widgets:update"

local function update()
	awful.spawn.easy_async_with_shell("amixer -D pulse sget Master", function(out)
		awesome.emit_signal(UPDATE_SIGNAL, out)
	end)
end

awesome.connect_signal("module::volume:up", function()
	awful.spawn.easy_async_with_shell(INC_VOLUME_CMD, function()
    update()
	end)
end)

awesome.connect_signal("module::volume:down", function()
	awful.spawn.easy_async_with_shell(DEC_VOLUME_CMD, function()
    update()
	end)
end)

awesome.connect_signal("module::volume:set", function(volume)
	if volume and type(volume) == "number" then
		if volume >= 0 and volume <= 100 then
			awful.spawn.easy_async_with_shell("amixer -D pulse sset Master " .. volume .. "%", function()
        update()
			end)
		end
	end
end)

awesome.connect_signal("module::volume:toggle", function()
	awful.spawn.easy_async_with_shell(TOG_VOLUME_CMD, function()
    update()
	end)
end)

gears.timer{
  timeout = 2,
  autostart = true,
  call_now = true,
  callback = function ()
    update()
  end
}
