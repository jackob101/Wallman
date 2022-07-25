local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")

local config = beautiful.tag

----------------------------------------
-- Mouse button binds for tags
----------------------------------------

local taglist_buttons = {
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

}

----    Tag parts

------      Group that contains index number and tasks
local group_widget = {
    {
        widget = wibox.container.margin,
        margins = config.label_margins,
        {
            widget = wibox.widget.textbox,
            align = "center",
            id = "text_role",
            forced_width = config.label_forced_width,
        },
    },
    {
        id = "task_list",
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.fixed.horizontal,
}

------      Mouse hover effect

local background_hover_widget = {
    widget = wibox.container.background,
    opacity = 0,
    id = "hover_background",
    bg = config.hover_color
}

------      Underline for tag showing selected tag and tags with urgent clients

local underline_widget = {
    layout = wibox.layout.align.vertical,
    expand = "inside",
    nil,
    nil,
    {
        widget = wibox.container.background,
        forced_height = config.underline_height,
        id = "background_role",
    }
}


----------------------------------------
-- Responsible for creating preview of tasks on tag
----------------------------------------
local function create_task_list(clients)

    local task_list = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = config.tasks_spacing,
    }

    for _, client in ipairs(clients) do
        task_list:add(wibox.widget({
            widget = wibox.widget.imagebox,
            image = client.icon,
        }))
    end

    return wibox.widget {
        widget = wibox.container.margin,
        top = config.tasks_top_margin or config.tasks_margins,
        bottom = config.tasks_bottom_margin or config.tasks_margins,
        right = config.tasks_right_margin or config.tasks_margins,
        task_list
    }
end

----    Updates the client list in group

local function update_callback(self, t)
    local clients = t:clients()
    local task_list = self:get_children_by_id("task_list")[1]
    task_list:reset()
    if #clients > 0 then
        task_list:add(create_task_list(clients))
    end
end

----    Apply the signal listener for hover effect

local function connect_hover_effect(widget)
    widget:connect_signal("mouse::enter", function()
        widget.opacity = 1
    end)

    widget:connect_signal("mouse::leave", function()
        widget.opacity = 0
    end)
end


----    Creates tag list for passed screen

local function create(s)
    return awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        widget_template = {
            {
                background_hover_widget,
                group_widget,
                underline_widget,
                layout = wibox.layout.stack,
            },
            widget = wibox.container.background,
            update_callback = update_callback,
            create_callback = function(self, t)
                widget = self:get_children_by_id("hover_background")[1]
                connect_hover_effect(widget)
                utils.cursor_hover(widget)
                update_callback(self, t)
            end,
        },
        buttons = taglist_buttons,
    })
end

return create
