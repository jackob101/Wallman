--- @class VolumePopupWidget : VolumeUpdatableWidget
--- @field volumeSlider Widget
--- @field volumeHeader Widget
--- @field volumeValue Widget
VolumePopupWidget = {
    volumeHeader = Wibox.widget({
        text = "Volume",
        font = Beautiful.volumePopupWidget.font,
        align = "left",
        valign = "center",
        widget = Wibox.widget.textbox,
    }),
    volumeValue = Wibox.widget({
        text = "0%",
        font = Beautiful.volumePopupWidget.font,
        align = "center",
        valign = "center",
        widget = Wibox.widget.textbox,
    }),
    volumeSlider = Wibox.widget({
        id = "volume_slider",
        bar_shape = Gears.shape.rounded_rect,
        bar_height = Beautiful.volumePopupWidget.sliderBarHeight,
        bar_color = Beautiful.volumePopupWidget.sliderBarColor,
        bar_active_color = Beautiful.volumePopupWidget.sliderBarActiveColor,
        handle_color = Beautiful.volumePopupWidget.sliderHandleColor,
        handle_shape = Gears.shape.circle,
        handle_width = Beautiful.volumePopupWidget.sliderHandleWidth,
        handle_border_color = Beautiful.volumePopupWidget.sliderHandleBorderColor,
        handle_border_width = Beautiful.volumePopupWidget.sliderHandleBorderWidth,
        maximum = 100,
        widget = Wibox.widget.slider,

    })
}
VolumePopupWidget.__index = VolumePopupWidget

--- @return VolumePopupWidget
function VolumePopupWidget.new(s)
    if not VolumeService and not VolumeService.isInitialized then
        return
    end

    --- @type VolumePopupWidget
    local newInstance = {}
    setmetatable(newInstance, VolumePopupWidget)

    newInstance.volume_overlay = newInstance:_generateWidgetTemplate(s)
    newInstance:_setUpSignals()
    newInstance.widgetIndex = s.index

    newInstance.timer = Gears.timer({
        timeout = 2,
        autostart = false,
        single_shot = true,
        callback = function()
            newInstance.volume_overlay.visible = false
        end,
    })

    VolumeService.connect(newInstance)
    return newInstance
end

--- @param newVolume number
--- @param isMute boolean
--- @param shouldDisplay boolean
function VolumePopupWidget:update(newVolume, isMute, shouldDisplay)
    VolumePopupWidget.volumeSlider:set_value(newVolume)
    VolumePopupWidget.volumeValue:set_text(newVolume .. "%")

    if shouldDisplay and Awful.screen.focused().index == self.widgetIndex then
        self.volume_overlay.visible = true
        self:startHideTimer()
    end
end

function VolumePopupWidget:startHideTimer()
    self.timer:again()
end

function VolumePopupWidget:stopHideTimer()
    self.timer:stop()
end

--- @param s Screen
function VolumePopupWidget:_generateWidgetTemplate(s)
    local overlay = Awful.popup({
        widget = {
            {
                {
                    {
                        layout = Wibox.layout.align.horizontal,
                        expand = "none",
                        self.volumeHeader,
                        nil,
                        self.volumeValue,
                    },
                    self.volumeSlider,
                    expand = "inside",
                    layout = Wibox.layout.fixed.vertical,
                },
                left = Beautiful.volumePopupWidget.leftBorderMargin,
                right = Beautiful.volumePopupWidget.rightBorderMargin,
                top = Beautiful.volumePopupWidget.topBorderMargin,
                bottom = Beautiful.volumePopupWidget.bottomBorderMargin,
                widget = Wibox.container.margin,
            },
            bg = Beautiful.volumePopupWidget.bg,
            shape = Beautiful.volumePopupWidget.shape,
            border_width = Beautiful.volumePopupWidget.boxBorderWidth,
            border_color = Beautiful.volumePopupWidget.boxBorderColor,
            widget = Wibox.container.background,
        },
        ontop = true,
        visible = false,
        type = "notification",
        screen = s,
        height = Beautiful.volumePopupWidget.height,
        width = Beautiful.volumePopupWidget.width,
        maximum_height = Beautiful.volumePopupWidget.height,
        maximum_width = Beautiful.volumePopupWidget.width,
        shape = Beautiful.volumePopupWidget.shape,
        bg = "#00000000",
        preferred_anchors = "middle",
        preferred_positions = { "left", "right", "top", "bottom" },
    })

    Awful.placement.bottom_right(overlay, {
        margins = {
            right = Beautiful.volumePopupWidget.spaceAround,
            bottom = Beautiful.volumePopupWidget.spaceAround,
            top = 0,
            left = 0,
        },
        honor_workarea = true,
    })

    return overlay
end

function VolumePopupWidget:_setUpSignals()
    self.volume_overlay:connect_signal("mouse::enter", function()
        self.timer:stop()
    end)

    self.volume_overlay:connect_signal("mouse::leave", function()
        self:startHideTimer()
    end)

    VolumePopupWidget.volumeSlider:connect_signal("property::value", function(_, newValue)
        VolumeService.set(newValue, false)
    end)
end

