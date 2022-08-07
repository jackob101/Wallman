--- @class TimeBarWidget : BaseWidget
TimeBarWidget = {}
TimeBarWidget.__index = TimeBarWidget


--- @return TimeBarWidget
function TimeBarWidget.new()
    local newBarTimeWidget = {}
    setmetatable(newBarTimeWidget, TimeBarWidget)

    local clock = Wibox.widget({
        widget = Wibox.widget.textclock,
        format = "%H:%M",
        font = Beautiful.bar_font,
    })

    newBarTimeWidget.widget = Wibox.widget({
         IconsHandler.icons.clock.widget("#FFFFFF"),
        clock,
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.bar_icon_text_spacing,
    })

    return newBarTimeWidget
end
