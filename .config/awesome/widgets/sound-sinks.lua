local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local utils = {}
local SINKS_CMD = [[sh -c "pactl list sinks short | awk '{print $2}'"]]

function utils.create_label(text)
  return wibox.widget {
    align = 'center',
    valign = 'center',
    text = text,
    fg = "#FF00FF",
    widget = wibox.widget.textbox,
  }
end

local volume_settings = wibox.widget {
  {
    text = 'TEst',
    fg = "#FFFFFF",
    widget = wibox.widget.textbox,
  },
  bg = "#000000",
  forced_width = 100,
  forced_height = 100,
  widget = wibox.container.background,
}

volume_settings.point = function(geo, args)

  local x = args.parent.width - geo.width;
  local y = (args.parent.height / 2 ) - (geo.height/2);

  return {x = x, y = y}

end

function utils.generate_widget()

  awful.spawn.easy_async(SINKS_CMD, function(stdout)

      local result = {}

      for line in stdout:gmatch("[^\r\n]+") do

        table.insert( result, utils.create_label(line))

      end

      table.insert(volume_settings, result)

  end
  )

  return volume_settings
end



function utils.get_input_sinks()


end

return utils
