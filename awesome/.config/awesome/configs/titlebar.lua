local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")
local icons = require("icons")
local config = beautiful.titlebar
----    Helper function to create title bar

---Creates new button for title bar of client
---@param action function Action that will be applied
---@param color string color of button
---@param tooltip string text that should be displayed when hovering
---@param image table wrapped icon table that comes from icons utils
local function create_button(color, action, tooltip, image)

    local widget = wibox.widget {
        widget = wibox.container.background,
        forced_width = config.control_button_width,
        bg = "#ffffff00",
        {
            layout = wibox.layout.align.horizontal,
            expand = "outside",
            nil,
            {
                widget = wibox.container.margin,
                margins = config.control_button_margins,
                image.widget(color),
            },
        }
    }

    utils.generate_tooltip(widget, tooltip)

    widget:connect_signal("button::release", action)
    widget:connect_signal("mouse::enter", function()
        widget.bg = config.control_button_hover_color
    end)
    widget:connect_signal("mouse::leave", function()
        widget.bg = "#FFFFFF00"
    end)

    return widget
end

-- Left side of the title bar

local function create_left_part(c, buttons)

    local floating_icon_widget = wibox.widget {
        widget = wibox.widget.textbox,
        opacity = 0,
        text = config.floating_symbol,
        font = config.floating_font,
    }

    local function set_opacity_when_floating(client)
        if client.floating then
            floating_icon_widget.opacity = 1
        else
            floating_icon_widget.opacity = 0
        end
    end

    --  To Initialize opacity
    set_opacity_when_floating(c)

    c:connect_signal("property::floating", function(client)
        set_opacity_when_floating(client)
    end)

    local application_icon_widget = wibox.widget {
        widget = wibox.container.margin,
        margins = config.icon_padding,
        {
            awful.titlebar.widget.iconwidget(c),
            layout = wibox.layout.fixed.horizontal,
        },
        buttons = buttons,
    }

    return wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = config.left_components_spacing,
        application_icon_widget,
        floating_icon_widget
    }
end

--  Middle part of the title bar

local function create_middle_part(c, buttons)
    return wibox.widget {
        {
            align = "center",
            widget = awful.titlebar.widget.titlewidget(c),
        },
        layout = wibox.layout.flex.horizontal,
        buttons = buttons
    }
end

--  Right part of the title bar


local function create_right_part(c)

    local minimize_button = create_button(config.minimize_color,
            function()
                c.minimized = not c.minimized
            end,
            "Minimize",
            icons.window_minimize)

    local maximize_button = create_button(config.maximize_color,
            function()
                c:maximize()
            end,
            "Maximize",
            icons.window_maximize)

    local close_button = create_button(config.close_color,
            function()
                c:kill()
            end,
            "Close application",
            icons.window_close)

    return wibox.widget {
        minimize_button,
        maximize_button,
        close_button,
        layout = wibox.layout.fixed.horizontal,
    }
end


----    Create title bar for each client

client.connect_signal("request::titlebars", function(c)

    -- buttons for the titlebar

    local buttons = gears.table.join(
            awful.button({}, 1, function()
                c:emit_signal("request::activate", "titlebar", { raise = true })
                awful.mouse.client.move(c)
            end),
            awful.button({}, 3, function()
                c:emit_signal("request::activate", "titlebar", { raise = true })
                awful.mouse.client.resize(c)
            end)
    )

    awful.titlebar(c):setup({
        --create_left_part(c, buttons),
        nil,
        create_middle_part(c, buttons),
        create_right_part(c),
        layout = wibox.layout.align.horizontal,
    })
end)
