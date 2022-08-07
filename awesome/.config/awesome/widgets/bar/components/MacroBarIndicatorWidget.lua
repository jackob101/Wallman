--- @class MacroBarIndicator : MacroUpdatable
--- @field widget Widget
MacroBarIndicator = {}
MacroBarIndicator.__index = MacroBarIndicator

--- @return MacroBarIndicator
function MacroBarIndicator.new()
    --- @type MacroBarIndicator
    local newInstance = {}
    setmetatable(newInstance, MacroBarIndicator)

    newInstance.widget = Wibox.widget({
        widget = Wibox.widget.textbox,
        visible = false,
        text = "Macro on"
    })

    MacroService.connect(newInstance)
    return newInstance
end


function MacroBarIndicator:update(isOn)
    if isOn then
        self.widget.visible = true
    else
        self.widget.visible = false
    end
end
