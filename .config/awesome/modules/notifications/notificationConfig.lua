local ruled = require("ruled")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = beautiful.xresources
local xrdb = xresources.get_current_theme()

-- stylua: ignore start



ruled.notification.connect_signal("request::rules", function()
    -- Add a red background for urgent notifications.

      ruled.notification.append_rule {
         rule = {},
         properties = {
            icon_size = 86,
            fg = xrdb.foreground,
            bg = xrdb.background .. "AA",
            width = 350,
            margin = 20,
         }
      }


      ruled.notification.append_rule {
         rule       = { urgency = "critical" },
         properties = {
            border_color = xrdb.color1,
            timeout = 0
         }
      }

      -- Or green background for normal ones.
      ruled.notification.append_rule {
         rule       = { urgency = "normal" },
         properties = {
         }
      }
end)

-- stylua: ignore end
