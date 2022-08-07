--- @class NotificationPopupWidget
local NotificationPopupWidget = {}
NotificationPopupWidget.__index = NotificationPopupWidget

--- @return NotificationPopupWidget
function NotificationPopupWidget.new()
    --- @type NotificationPopupWidget
    local newInstance = {}
    setmetatable(newInstance, NotificationPopupWidget)

    local panel = Awful.popup({
        widget = {
            widget = Wibox.container.background,
            bg = '#FFFFFF',
            forced_width = 200,
            forced_height = 200,
        },
        screen = s,
        ontop = true,
        placement = function(self)
            return Awful.placement.bottom_right(self,{
                margins = {
                    bottom = Beautiful.bar.barHeight + Beautiful.notification_center.bottomMargin,
                    right = 20,
                } })
        end,
        visible = false,
    })


    return newInstance
end


