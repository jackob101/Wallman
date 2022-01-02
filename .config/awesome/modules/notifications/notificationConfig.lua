local ruled = require("ruled")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = beautiful.xresources
local xrdb = xresources.get_current_theme()
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")

-- stylua: ignore start

-- naughty.config.defaults.shape = function(cr, w, h)
--   gears.shape.rounded_rect(cr, w, h, dpi(6))
-- end


ruled.notification.connect_signal("request::rules", function()

    ruled.notification.append_rule {
      rule = {},
      properties = {
        icon_size = 86,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        width = 350,
        margin = 20,
        border_width = 2,
      }
    }


    ruled.notification.append_rule {
      rule       = { urgency = "critical" },
      properties =
        {
          timeout = 0,
          border_color = beautiful.bg_urgent,
        }
    }

    -- Or green background for normal ones.
    ruled.notification.append_rule {
      rule       = { urgency = "normal" },
      properties = {
      }
    }
end)
