--- @class Systray : BaseWidget
Systray = {}
Systray.__index = Systray

--- @return Systray
function Systray.new(s)

    if s.index ~= 1 then
        return nil
    end

    local newSystray = {}
    setmetatable(newSystray, Systray)

    newSystray.widget = Wibox.widget({
        widget = Wibox.widget.systray,
        screen = "primary",
    })

    return newSystray
end
