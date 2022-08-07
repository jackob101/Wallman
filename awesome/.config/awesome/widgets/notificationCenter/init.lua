local NotificationPopupWidget = require((...) .. ".popup")

--- @class NotificationCenterWidget
---
NotificationCenter = {}
NotificationCenter.__index = NotificationCenter

local path = select('1', ...):match(".+%.") or ""


--- @param s Screen
--- @return NotificationCenterWidget
function NotificationCenter.new(s)

    --- @type NotificationCenterWidget
    local newInstance = {}
    setmetatable(newInstance, NotificationCenter)

    --- @type NotificationPopupWidget


    return newInstance
end

