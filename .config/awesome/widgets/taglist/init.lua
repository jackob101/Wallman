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
      filter = awful.widget.taglist.filter.noempty,
      widget_template = {
        {
          {
            {
              id = "text_role",
              widget = wibox.widget.textbox,
              align = "center",
            },
            id = "text_color",
            widget = wibox.container.background,
          },
          {
            nil,
            nil,
            {
              point = function (geo, args)
                return {
                  x = args.parent.width - geo.width,
                  y = args.parent.height - geo.height,
                }
              end,
              id = "background_role",
              forced_height = 2,
              widget = wibox.container.background,

            },
            widget = wibox.layout.align.vertical,
          },
          widget = wibox.layout.stack,
        },
        forced_width = 25,
        widget = wibox.container.background,
        update_callback = function(self, c3 ,index, object)
        end
      },
      buttons = taglist_buttons,
})end

return initTagList
