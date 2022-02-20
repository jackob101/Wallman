local wibox = require("wibox")
local icons = require("icons")
local awful = require("awful")
local utils = require("utils")
local beautiful = require("beautiful")
local gears =  require("gears")

local logoFunctions = {}

function logoFunctions.create_widget()
  local logo = wibox.widget {
    {
      {
        image = icons.logo,
        resize = true,
        widget = wibox.widget.imagebox,
      },
      right = 10,
      left = 10,
      top = 4,
      bottom = 4,
      widget = wibox.container.margin,
      buttons = {
        awful.button({}, 1,nil ,function ()
            awful.spawn(os.getenv("HOME") .. "/.config/rofi/launcher.sh")
        end)
      },
    },
    widget = wibox.container.background;
  }

  local old_cursor, old_wibox
  logo:connect_signal("mouse::enter", function(c)
      local wb = mouse.current_wibox
      old_cursor, old_wibox = wb.cursor, wb
      wb.cursor = "hand1"
      c:set_bg(beautiful.bg_focus)
  end)

  logo:connect_signal("mouse::leave", function(c)
      if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
      end
      c:set_bg(beautiful.bg_normal)
  end)

  logo:connect_signal("button::press", function (c)
      if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
      end
      c:set_bg(beautiful.bg_normal)
  end)

  return logo
end

return logoFunctions
