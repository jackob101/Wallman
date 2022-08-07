--- @class TaskListWidget : BaseWidget
TaskListWidget = {
    _tasklistButtons = {
        Awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", { raise = true })
            end
        end),
        Awful.button({}, 2, function(c)
            c:kill()
        end),
        Awful.button({}, 4, function()
            Awful.client.focus.byidx(1)
        end),
        Awful.button({}, 5, function()
            Awful.client.focus.byidx(-1)
        end)

    }
}
TaskListWidget.__index = TaskListWidget

--- @return TaskListWidget
function TaskListWidget.new(s)
    --- @type TaskListWidget
    local newTaskListWidget = {}
    setmetatable(newTaskListWidget, TaskListWidget)

    newTaskListWidget.widget = Awful.widget.tasklist({
        screen = s,
        filter = Awful.widget.tasklist.filter.currenttags,
        layout = {
            spacing = Beautiful.task_spacing,
            layout = Wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                nil,
                {
                    {
                        id = "icon_role",
                        widget = Wibox.widget.imagebox,
                        scaling_quality = "good",
                    },
                    widget = Wibox.container.margin,
                    top = Beautiful.task.top_margin,
                    bottom = Beautiful.task.bottom_margin,
                    left = Beautiful.task.left_margin,
                    right = Beautiful.task.right_margin,
                },
                layout = Wibox.layout.align.horizontal,
                expand = "outside",
            },
            id = "background_role",
            widget = Wibox.container.background,
            create_callback = function(self, c)
                Utils.hover_effect(self)
                Utils.generate_tooltip(self, c.class)
            end,
        },
        buttons = TaskListWidget._tasklistButtons,
    })

    return newTaskListWidget
end

