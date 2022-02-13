local wibox = require("wibox")
local icons = require("icons")
local awful = require("awful")
local utils = require("utils")

local logo = wibox.widget {
  {
    image = icons.logo,
    resize = true,
    widget = wibox.widget.imagebox,
    buttons = {
      awful.button({}, 1,nil ,function ()
         awful.spawn(os.getenv("HOME") .. "/.config/rofi/launcher.sh")
      end)
    },
  },

  right = 5,
  left = 5,
  top = 2,
  bottom = 2,
  widget = wibox.container.margin,
}

local old_cursor, old_wibox
logo:connect_signal("mouse::enter", function(c)
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
logo:connect_signal("mouse::leave", function(c)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)

utils.generate_tooltip(logo, "Click to show application launcher")

return logo
