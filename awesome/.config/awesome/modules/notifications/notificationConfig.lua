local ruled = require("ruled")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")
local menubar = require("menubar")
local theme = beautiful.notification

local is_dnd_on = false

ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule({
        rule = { urgency = "critical" },
        properties = {
            timeout = 0,
            border_color = theme.border_urgent,
        },
    })

    ruled.notification.append_rule({
        rule = { urgency = "normal" },
        properties = {
            timeout = 5,
            implicit_timeout = 5,
            border_color = theme.border_normal
        },
    })
    ruled.notification.append_rule({
        rule = { urgency = "low" },
        properties = {
            implicit_timeout = 5,
            border_color = theme.border_normal
        },
    })
end)

-- Some magic that fixed missing icons
naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then
        return
    end

    local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then
        n.icon = path
    end
end)

awesome.connect_signal("modules::dnd:changed", function(new)
    is_dnd_on = new
end)

naughty.connect_signal("request::display", function(n)
    if not is_dnd_on then
        local actions_template = wibox.widget({
            notification = n,
            base_layout = wibox.widget({
                spacing = dpi(0),
                layout = wibox.layout.flex.horizontal,
            }),
            widget_template = {
                {
                    {
                        {
                            {
                                id = "text_role",
                                font = "Inter Regular 10",
                                widget = wibox.widget.textbox,
                            },
                            widget = wibox.container.place,
                        },
                        widget = wibox.container.background,
                    },
                    bg = beautiful.groups_bg,
                    shape = gears.shape.rounded_rect,
                    forced_height = dpi(30),
                    widget = wibox.container.background,
                },
                margins = dpi(4),
                widget = wibox.container.margin,
            },
            style = { underline_normal = false, underline_selected = true },
            widget = naughty.list.actions,
        })

        local left_part = wibox.widget({
            widget = wibox.container.margin,
            right = dpi(10),
            {
                {
                    naughty.widget.icon,
                    widget = wibox.container.place,
                    valign = "center",
                    halign = "center",
                },
                widget = wibox.container.background,
            }
        }
        )

        local right_part = wibox.widget({
            {
                {
                    align = "center",
                    markup = "<b>" .. n.title .. "</b>",
                    font = beautiful.notification_title_font,
                    ellipsize = "end",
                    widget = wibox.widget.textbox,
                    forced_height = 25,
                },
                {
                    widget = wibox.container.background,
                    forced_height = theme.message_height,
                    {
                        align = "center",
                        --valign = "top",
                        wrap = "char",
                        widget = naughty.widget.message,
                    }
                },
                actions_template,
                expand = "inside",
                spacing = 5,
                layout = wibox.layout.align.vertical,
            },
            margins = beautiful.notification_box_margin,
            widget = wibox.container.margin,
        })

        naughty.layout.box({
            notification = n,
            type = "notification",
            screen = awful.screen.focused(),
            shape = gears.shape.rectangle,
            bg = theme.bg,
            position = "top_right",
            border_width = dpi(2),
            --border_color = theme.border_color,
            border_color = n.border_color,
            widget_template = {
                {
                    widget = wibox.container.margin,
                    margins = theme.box_padding,
                    {
                        left_part,
                        right_part,
                        layout = wibox.layout.align.horizontal
                    },
                },

                widget = wibox.container.background,
                forced_width = theme.width,
            },
        })
    end
end)
