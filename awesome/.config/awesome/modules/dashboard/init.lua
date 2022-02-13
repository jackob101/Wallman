local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require('awful')
local utils = require("utils")
local profile = require("modules.dashboard.profile")

local dashboard = wibox({

    visible = false,
    ontop = true,
    type = "dock",
    screen = screen.primary,
    bg = beautiful.bg_normal .. "55",
    x = 0,
    y = beautiful.bar_height,
    width = awful.screen.focused().geometry.width,
    height = awful.screen.focused().geometry.height - beautiful.bar_height,

})

local keygrabber

local function getKeygrabber()
  return awful.keygrabber {
    keypressed_callback = function(_, mod, key)
      if key == "Escape" then
        dashboard.visible = false
        keygrabber:stop()
        return
      end

      -- don't do anything for non-alphanumeric characters or stuff like F1, Backspace, etc
      if key:match("%W") or string.len(key) > 1 and key ~= "Escape" then
        return
      end

    end,
  }
end

keygrabber = getKeygrabber()

dashboard.toggle = function ()

  dashboard.visible = not dashboard.visible

  keygrabber:stop();

  if dashboard.visible then
    keygrabber = getKeygrabber()
    keygrabber:start()
  end
end

dashboard.close = function ()
  dashboard.visible = false
  keygrabber:stop()
end

awesome.connect_signal("dashboard::toggle", dashboard.toggle)
awesome.connect_signal("dashboard::close", dashboard.close)

dashboard:setup {


  {
    utils.draw_box(profile, 250, 250),
    layout = wibox.layout.align.horizontal,
  },
  halign = 'center',
  valign = 'center',
  widget = wibox.container.place,
}

return dashboard
