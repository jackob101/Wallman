--- @class NotificationService : Initializable
--- @field dndCheck fun(n: Notification) This function checks if dnd is on when DNDService is present else always return true
NotificationService = {}

function NotificationService.init()

    if NotificationService.isInitialized then
        return
    end

    NotificationService._setUpDND()
    NotificationService._setUpRules()
    NotificationService._setUpIconsSignal()
    NotificationService._setUpNotificationDisplay()
    NotificationService.isInitialized = true

end

function NotificationService._setUpDND()
    if DoNotDisturbService and DoNotDisturbService.isInitialized then
        NotificationService.dndCheck = function(n)
            return not DoNotDisturbService.isDNDOn or n._private.force_display
        end
    else
        NotificationService.dndCheck = function(n)
            return true
        end
    end
end

function NotificationService._setUpRules()
    Ruled.notification.connect_signal("request::rules", function()
        Ruled.notification.append_rule({
            rule = { urgency = "critical" },
            properties = {
                timeout = 0,
                border_color = Beautiful.notification.borderUrgent
            },
        })

        Ruled.notification.append_rule({
            rule = { urgency = "normal" },
            properties = {
                timeout = 5,
                implicit_timeout = 5,
                border_color = Beautiful.notification.borderNormal
            },
        })
        Ruled.notification.append_rule({
            rule = { urgency = "low" },
            properties = {
                implicit_timeout = 5,
                border_color = Beautiful.notification.borderNormal
            },
        })
    end)
end

function NotificationService._setUpIconsSignal()
    -- Some magic that fixed missing icons
    Naughty.connect_signal("request::icon", function(n, context, hints)
        if context ~= "app_icon" then
            return
        end

        local path = Menubar.utils.lookup_icon(hints.app_icon) or Menubar.utils.lookup_icon(hints.app_icon:lower())

        if path then
            n.icon = path
        end
    end)
end

function NotificationService._getActionTemplateWidget()
    return Wibox.widget({
        notification = n,
        base_layout = Wibox.widget({
            spacing = Dpi(0),
            layout = Wibox.layout.flex.horizontal,
        }),
        widget_template = {
            {
                {
                    {
                        {
                            id = "text_role",
                            font = "Inter Regular 10",
                            widget = Wibox.widget.textbox,
                        },
                        widget = Wibox.container.place,
                    },
                    widget = Wibox.container.background,
                },
                bg = Beautiful.groups_bg,
                shape = Gears.shape.rounded_rect,
                forced_height = Dpi(30),
                widget = Wibox.container.background,
            },
            margins = Dpi(4),
            widget = Wibox.container.margin,
        },
        style = { underline_normal = false, underline_selected = true },
        widget = Naughty.list.actions,
    })
end

function NotificationService._getIconPartWidget()
    return Wibox.widget({
        widget = Wibox.container.margin,
        right = Beautiful.notification.iconRightMargin,
        {
            {
                Naughty.widget.icon,
                widget = Wibox.container.place,
                valign = "center",
                halign = "center",
            },
            widget = Wibox.container.background,
        }
    }
    )
end

--- @param n Notification
function NotificationService._getTextPartWidget(n)
    return Wibox.widget({
        {
            {
                align = "center",
                markup = "<b>" .. n.title .. "</b>",
                font = Beautiful.notification.titleFont,
                ellipsize = "end",
                widget = Wibox.widget.textbox,
                forced_height = Beautiful.notification.titleHeight,
            },
            {
                widget = Wibox.container.background,
                forced_height = Beautiful.notification.messageHeight,
                {
                    align = "center",
                    --valign = "top",
                    wrap = "char",
                    widget = Naughty.widget.message,
                }
            },
            NotificationService._getActionTemplateWidget(),
            expand = "inside",
            spacing = 5,
            layout = Wibox.layout.align.vertical,
        },
        margins = Beautiful.notification_box_margin,
        widget = Wibox.container.margin,
    })

end

function NotificationService._setUpNotificationDisplay()
    Naughty.connect_signal("request::display", function(n)
        if NotificationService.dndCheck(n) then

            local iconWidget = NotificationService._getIconPartWidget()
            local textWidget = NotificationService._getTextPartWidget(n)

            Naughty.layout.box({
                notification = n,
                type = "notification",
                screen = Awful.screen.focused(),
                shape = Gears.shape.rectangle,
                bg = Beautiful.notification.bg,
                position = Beautiful.notification.position,
                border_width = Beautiful.notification.borderWidth,
                border_color = n.border_color,
                widget_template = {
                    {
                        widget = Wibox.container.margin,
                        margins = Beautiful.notification.borderPadding,
                        {
                            iconWidget,
                            textWidget,
                            layout = Wibox.layout.align.horizontal
                        },
                    },

                    widget = Wibox.container.background,
                    forced_width = Beautiful.notification.width
                },
            })
        end
    end)
end

