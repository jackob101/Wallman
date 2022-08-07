local icons = require("icons")

--- @class DNDUpdatable : BaseWidget
--- @field update fun(newStatus: boolean)

--- @class DoNotDisturbService : Initializable
--- @field isDNDOn boolean
--- @field toUpdate DNDUpdatable[]
DoNotDisturbService = {
    isDNDOn = false,
    toUpdate = {}
}

--- @return DoNotDisturbService
function DoNotDisturbService.init()
    if DoNotDisturbService.isInitialized then
        return
    end

    DoNotDisturbService._initKeybinds()

    DoNotDisturbService.isInitialized = true
end

--- @param widget DNDUpdatable
function DoNotDisturbService.connect(widget)
    table.insert(DoNotDisturbService.toUpdate, widget)
end

function DoNotDisturbService.update()
    for _, v in ipairs(DoNotDisturbService.toUpdate) do
        v.update(DoNotDisturbService.isDNDOn)
    end
end

function DoNotDisturbService.toggle()

    if not DoNotDisturbService.isDNDOn then
        Naughty.notification({
            title = "Do not disturb",
            message = "Do not disturb has been turned on",
            icon = icons.bell_slash,
            force_display = true,
            store = false,
        })
    else
        Naughty.notification({
            title = "Do not disturb",
            message = "Do not disturb has been turned off",
            icon = icons.bell,
            force_display = true,
            store = false,
        })
    end

    DoNotDisturbService.isDNDOn = not DoNotDisturbService.isDNDOn

    DoNotDisturbService.update()
end

function DoNotDisturbService._initKeybinds()

    Keybinds.connectForGlobal(Gears.table.join(
            Awful.key(
                    { ModKey, "Shift" },
                    "t",
                    function()
                        DoNotDisturbService.toggle()
                    end,
                    { description = "Toggle DND mode", group = "DND" }
            )
    ))

end
