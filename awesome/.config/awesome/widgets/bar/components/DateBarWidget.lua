
--- @class DateBarWidget
DateBarWidget = {}
DateBarWidget.__index = DateBarWidget

--- @return DateBarWidget
function DateBarWidget.new()
    local newDateWidget = {}
    setmetatable(newDateWidget, DateBarWidget)

    local calendar = Wibox.widget({
        widget = Wibox.widget.textclock,
        format = "%a %b %d",
        font = Beautiful.bar.font,
    })

    newDateWidget.widget = Wibox.widget({
        IconsHandler.icons.calendar.widget(),
        calendar,
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.bar.barIconTextSpacing,
    })

    return newDateWidget
end