local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require('gears')

local utils = {}

function utils.create_stylesheet (class_name)
  return "."..class_name.."{color: ".. beautiful.fg_normal .. ";}"
end

function utils.create_widget_with_icon(image, class_name, widget)
  return wibox.widget {
    {
      {
        stylesheet = utils.create_stylesheet(class_name),
        image = image,
        widget = wibox.widget.imagebox,
      },
      right = 4,
      left = 4,
      widget = wibox.container.margin,
    },
    widget,
    layout = wibox.layout.align.horizontal,
  }

end

function utils.draw_box(content, width, height)
  local box = wibox.widget {
    {

      {
        content,
        margins = beautiful.dashboard_margin,
        widget = wibox.container.margin,
      },
      valign = "center",
      halign = "center",
      widget = wibox.container.place,
    },
    widget = wibox.container.background,
    forced_width = width,
    forced_height = height,
    border_width = beautiful.dashboard_border_width,
    border_color = beautiful.dashboard_border_color,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(5))
    end,
    bg = beautiful.bg_normal,
  }

  return box
end

return utils
