local awful = require("awful")
local gears = require("gears")
local modkey = require("configs.keys.mod").modkey
local wibox = require("wibox")
local beautiful = require('beautiful')
local naughty = require("naughty")

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
      t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
  end),
  awful.button({}, 4, function(t)
      awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
      awful.tag.viewprev(t.screen)
  end)
)

function initTagList(s)
  return awful.widget.taglist({
      screen = s,
      filter = awful.widget.taglist.filter.all,
      widget_template = {
        {
          id = "text_role",
          widget = wibox.widget.textbox,
          align = "center",
        },
        forced_width = 25,
        id = "background_role",
        widget = wibox.container.background,
      },
      buttons = taglist_buttons,
})end

return initTagList
