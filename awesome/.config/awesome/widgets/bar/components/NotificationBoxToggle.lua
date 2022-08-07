--- @class  CentralPanelToggle : BaseWidget
NotificationBoxToggle = {}
NotificationBoxToggle.__index = NotificationBoxToggle

--- @return  CentralPanelToggle
function NotificationBoxToggle.new()
    --- @type TaskListWidget
    local newInstance = {}
    setmetatable(newInstance, NotificationBoxToggle)

    local button = Wibox.widget({
        widget = Wibox.container.background,
        IconsHandler.icons.bell.widget(Beautiful.fg_normal)
    })

    Utils.cursor_hover(button)
    Utils.generate_tooltip(button, "Toggle notification center")

    button:buttons(Gears.table.join(Awful.button({}, 1, function()
        Awful.screen.focused().central_panel:toggle()
    end)
    ))

    newInstance.widget = button

    return newInstance
end