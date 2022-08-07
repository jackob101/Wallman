--- @class ClickableContainer
--- @field widget Widget
--- @field callback function
ClickableContainer = {}
ClickableContainer.__index = ClickableContainer

--- @return ClickableContainer
--- @param widget Widget
--- @param callback function
function ClickableContainer.new(widget, callback)
    --- @type ClickableContainer
    local newClickableContainer = {}
    setmetatable(newClickableContainer, ClickableContainer)

	newClickableContainer.widget = Wibox.widget({
		widget,
		widget = Wibox.container.background,
	})

    newClickableContainer.callback = callback

    newClickableContainer.widget:connect_signal("mouse::enter", newClickableContainer.mouseEnter)
    newClickableContainer.widget:connect_signal("mouse::leave", newClickableContainer.mouseLeave)
    newClickableContainer.widget:connect_signal('button::press', newClickableContainer.mousePress)
    newClickableContainer.widget:connect_signal('button::release', newClickableContainer.mouseRelease)

    return newClickableContainer
end

function ClickableContainer:mouseEnter()
    self.widget.bg = Beautiful.clickableContainer.hoverBg

    -- Hm, no idea how to get the wibox from this signal's arguments...
    local w = mouse.current_wibox
    if w then
        self._old_cursor, self._old_wibox = w.cursor, w
        w.cursor = "hand1"
    end
end

function ClickableContainer:mouseLeave()
    self.widget.bg = Beautiful.clickableContainer.bg
    if self._old_wibox then
        self._old_wibox.cursor = self._old_cursor
        self._old_wibox = nil
    end
end

function ClickableContainer:mousePress()
    self.widget.bg = Beautiful.clickableContainer.pressBg
end

function ClickableContainer:mouseRelease()
    self.widget.bg = Beautiful.clickableContainer.hoverBg
    self.callback()
end