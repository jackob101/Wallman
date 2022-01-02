local wibox = require("wibox")
local beautiful = require("beautiful")

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
      margins = 4,
      widget = wibox.container.margin,
    },
    widget,
    layout = wibox.layout.align.horizontal,
  }

end

return utils
