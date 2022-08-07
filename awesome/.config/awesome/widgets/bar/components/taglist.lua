--- @class TagListWidget : BaseWidget
--- @field _taglistButtons
TagListWidget = {
    _taglistButtons = {
        Awful.button({}, 1, function(t)
            t:view_only()
        end),
        Awful.button({ ModKey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        Awful.button({}, 3, Awful.tag.viewtoggle),
        Awful.button({ ModKey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        Awful.button({}, 4, function(t)
            Awful.tag.viewnext(t.screen)
        end),
        Awful.button({}, 5, function(t)
            Awful.tag.viewprev(t.screen)
        end)

    },
}
TagListWidget.__index = TagListWidget

--- @return TagListWidget
function TagListWidget.new(s)
    local newInstance = {}
    setmetatable(newInstance, TagListWidget)

    newInstance.widget = Awful.widget.taglist({
        screen = s,
        filter = Awful.widget.taglist.filter.noempty,
        buttons = TagListWidget._taglistButtons,
        widget_template = {
            {
                {
                    widget = Wibox.container.background,
                    opacity = 0,
                    id = "hover_background",
                    bg = Beautiful.tag.hover_color
                },
                {
                    {
                        widget = Wibox.container.margin,
                        margins = Beautiful.tag.label_margins,
                        {
                            widget = Wibox.widget.textbox,
                            align = "center",
                            id = "text_role",
                            forced_width = Beautiful.tag.label_forced_width,
                        },
                    },
                    {
                        id = "task_list",
                        layout = Wibox.layout.fixed.horizontal,
                    },
                    layout = Wibox.layout.fixed.horizontal,
                },
                {
                    layout = Wibox.layout.align.vertical,
                    expand = "inside",
                    nil,
                    nil,
                    {
                        widget = Wibox.container.background,
                        forced_height = Beautiful.tag.underline_height,
                        id = "background_role",
                    }
                },
                layout = Wibox.layout.stack,
            },
            widget = Wibox.container.background,
            update_callback = TagListWidget._update_callback,
            create_callback = function(self, t)
                local widget = self:get_children_by_id("hover_background")[1]
                TagListWidget._connect_hover_effect(widget)
                Utils.cursor_hover(widget)
                TagListWidget._update_callback(self, t)
            end,
        },
    })

    return newInstance
end

function TagListWidget._create_task_list(clients)

    local task_list = Wibox.widget {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.tag.tasks_spacing,
    }

    for _, client in ipairs(clients) do
        task_list:add(Wibox.widget({
            widget = Wibox.widget.imagebox,
            image = client.icon,
        }))
    end

    return Wibox.widget {
        widget = Wibox.container.margin,
        top = Beautiful.tag.tasks_top_margin or Beautiful.tag.tasks_margins,
        bottom = Beautiful.tag.tasks_bottom_margin or Beautiful.tag.tasks_margins,
        right = Beautiful.tag.tasks_right_margin or Beautiful.tag.tasks_margins,
        task_list
    }
end

--- @param widget Widget
function TagListWidget._connect_hover_effect(widget)
    widget:connect_signal("mouse::enter", function(self)
        self.opacity = 1
    end)

    widget:connect_signal("mouse::leave", function(self)
        self.opacity = 0
    end)
end


function TagListWidget._update_callback(widget, t)
    local clients = t:clients()
    local task_list = widget:get_children_by_id("task_list")[1]
    task_list:reset()
    if #clients > 0 then
        task_list:add(TagListWidget._create_task_list(clients))
    end
end
