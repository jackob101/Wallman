load_all("widgets", {
    "bar",
    "utils",
    "ExitScreen",
    "VolumePopupWidget",
    "notificationCenter",
})

--- @type BaseWidget[]
local widgetsForEachScreen = {
    StatusBar,
    VolumePopupWidget,
    NotificationCenter,
}

--- @type BaseWidget[]
local widget = {
}

Awful.screen.connect_for_each_screen(function(s)
    for _, service in pairs(widgetsForEachScreen) do
        if service then
            service.new(s)
        end
    end
end)

for _, service in pairs(widget) do
    if service then
        service.new()
    end
end

