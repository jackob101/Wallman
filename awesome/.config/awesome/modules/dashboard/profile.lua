local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("icons")
local awful = require("awful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local name = wibox.widget {
  text = "This is test",
  align = "center",
  font = "Inter 18",
  widget = wibox.widget.textbox,
}

local uptime = wibox.widget{
  text = "up 0 min",
  align = "center",
  widget = wibox.widget.textbox,
}

local profile_box = wibox.widget {

  nil,
  {
    {
      image = icons.default,
      valign = 'center',
      halign = 'center',
      widget = wibox.widget.imagebox,
    },
    widget = wibox.container.background,
    shape = function(cr, width, height)
      gears.shape.circle(cr, width, height)
    end,
  },
  {
    {
      {
        name,
        fg = beautiful.accent3,
        widget = wibox.container.background,
      },
      uptime,
      spacing = dpi(2),
      layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.fixed.vertical
  },

  spacing = dpi(16),
  layout = wibox.layout.align.vertical
}


local update_name = function()

  awful.spawn.easy_async_with_shell("whoami",
    function(stdout)
      local out = stdout:gsub('^%s*(.-)%s*$', '%1')
      name.text = out
  end)
end



local update_uptime = function()
  awful.spawn.easy_async_with_shell("uptime -p",
    function(stdout)
      local out = stdout:gsub('^%s*(.-)%s*$', '%1')
      uptime.text = out
  end)
end

update_name()
update_uptime()

awful.widget.watch("uptime -p", 60, function(_, stdout)
    -- Remove trailing whitespaces
    local out = stdout:gsub('^%s*(.-)%s*$', '%1')--:gsub(", ", ",\n")
    uptime.text = out
end)

return profile_box
