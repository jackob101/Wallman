
--- @class VolumeBarWidget : VolumeUpdatableWidget
VolumeBarWidget = {}
VolumeBarWidget.__index = VolumeBarWidget

--- @return VolumeBarWidget
function VolumeBarWidget.new()
    --- @type VolumeBarWidget
    local newVolumeBarWidget = {}
    setmetatable(newVolumeBarWidget, VolumeBarWidget)

    newVolumeBarWidget.icon_widget = Wibox.widget({
        resize = true,
        widget = Wibox.widget.imagebox,
    })

    newVolumeBarWidget.text_widget = Wibox.widget({
        text = "",
        widget = Wibox.widget.textbox,
    })

    newVolumeBarWidget.widget = Wibox.widget({
        {
            {
                newVolumeBarWidget.icon_widget,
                widget = Wibox.container.margin,
                margins = Beautiful.volumeBarWidget.barIconMargin
            },
            newVolumeBarWidget.text_widget,
            layout = Wibox.layout.fixed.horizontal,
            spacing = Beautiful.volumeBarWidget.barIconTextSpacing
        },
        widget = Wibox.container.background,
    })

    newVolumeBarWidget.tooltip = Utils.generate_tooltip(newVolumeBarWidget.widget, "Click to mute")

    newVolumeBarWidget.widget:connect_signal("button::press", function(_, _, _, b)
        if b == 1 then
            VolumeService.toggle()
        elseif b == 3 then
            Awful.spawn("pavucontrol")
        elseif b == 4 then
            VolumeService.increase()
        elseif b == 5 then
            VolumeService.decrease()
        end
    end)

    -- TODO Refactor after Utils are refactored
    local old_cursor, old_wibox
    newVolumeBarWidget.widget:connect_signal("mouse::enter", function()
        local w = mouse.current_wibox
        old_cursor, old_wibox = w.cursor, w
        w.cursor = "hand1"
    end)
    newVolumeBarWidget.widget:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    VolumeService.connect(newVolumeBarWidget)
    return newVolumeBarWidget
end

--- @param color VolumeBarWidgetTheme
function VolumeBarWidget:setNewStyle(icon, color)
    self.icon_widget.image = icon
    self.icon_widget.stylesheet = "#image{fill: " .. color .. ";}"
    self.widget.fg = color
end

function VolumeBarWidget:update(newVolume, isMute)
    if isMute then
        self:setNewStyle(IconsHandler.icons.volume_mute.path, Beautiful.volumeBarWidget.mutedFg)
        self.tooltip.text = "Click to unmute"
        self.text_widget.text = "Muted"
    else
        if newVolume >= 75 then
            self:setNewStyle(IconsHandler.icons.volume_high.path, Beautiful.volumeBarWidget.highFg)
        elseif newVolume < 75 and newVolume >= 35 then
            self:setNewStyle(IconsHandler.icons.volume_medium.path, Beautiful.volumeBarWidget.highFg)
        else
            self:setNewStyle(IconsHandler.icons.volume_low.path, Beautiful.volumeBarWidget.highFg)
        end
        self.tooltip.text = "Click to mute"
        self.text_widget.text = newVolume .. "%"
    end
end