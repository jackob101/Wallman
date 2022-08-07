--- @class TilingStatusWidget : BaseWidget
TilingStatusWidget = {
    widgets = {}
}
TilingStatusWidget.__index = TilingStatusWidget

--- @return TilingStatusWidget
function TilingStatusWidget.new(s)
    --- @type TilingStatusWidget
    local newTilingStatusWidget = {}
    setmetatable(newTilingStatusWidget, TilingStatusWidget)


    tag.connect_signal("property::selected", TilingStatusWidget._updateFromTag)
    tag.connect_signal("property::layout", TilingStatusWidget._updateFromTag)

    client.connect_signal("property::floating", TilingStatusWidget._updateFromClient)
    client.connect_signal("request::activate", TilingStatusWidget._updateFromClient)

    local tag_layout = {
        widget = Wibox.widget.textbox,
        font = Beautiful.font,
        id = "tag_layout"
    }

    local client_layout = {
        widget = Wibox.widget.textbox,
        font = Beautiful.font,
        id = "client_layout"
    }

    local widget = Wibox.widget {
        widget = Wibox.container.background,
        bg = Beautiful.tilingStatus.bg,
        fg = Beautiful.tilingStatus.fg,
        {
            widget = Wibox.container.margin,
            left = Beautiful.tilingStatus.leftMargin,
            right = Beautiful.tilingStatus.rightMargin,
            {
                layout = Wibox.layout.fixed.horizontal,
                tag_layout,
                client_layout
            }
        }
    }

    if TilingStatusWidget.widgets == nil then
        TilingStatusWidget.widgets = setmetatable({}, { __mode = "kv" })
    end

    TilingStatusWidget.widgets[s.index] = widget

    TilingStatusWidget._updateFromTag(s.selected_tag)

    newTilingStatusWidget.widget = widget

    return newTilingStatusWidget
end

function TilingStatusWidget._updateFromTag(t)
    local s = t.screen
    local w = TilingStatusWidget.widgets[s.index]
    if w then
        local tag_layout = Awful.layout.getname(Awful.layout.get(s))
        w:get_children_by_id("tag_layout")[1].text = firstToUpper(tag_layout)
    end
end

function TilingStatusWidget._updateFromClient()
    local c = client.focus
    if c then
        local w = TilingStatusWidget.widgets[c.screen.index]
        if w then
            local client_layout = w:get_children_by_id("client_layout")[1]
            if c.floating then
                client_layout.text = " : Floating"
            else
                client_layout.text = ""
            end
        end
    end
end
