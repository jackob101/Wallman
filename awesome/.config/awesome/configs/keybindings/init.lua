--- @class Keybinds
--- @field global Key[]
--- @field client Key[]
Keybinds = {
    global = {},
    client = {},
    macros = {},
    isInitialized = false
}

function Keybinds.init()

    if Keybinds.isInitialized then
        return
    end

    local keybindsToInit = {
        "AwesomeKeybinds",
        "ClientKeybinds",
        "LauncherKeybinds",
        "LayoutKeybinds",
        "TagsKeybinds",
        "ScreenKeybinds",
    }

    for _, v in ipairs(keybindsToInit) do
        require("configs.keybindings." .. v)()
    end

    root.keys(Keybinds.global)

    Keybinds.isInitialized = true
end

--- @param joinMacros boolean
function Keybinds.refresh(joinMacros)
    if joinMacros then
        root.keys(Gears.table.join(Keybinds.global, Keybinds.macros))
    else
        root.keys(Keybinds.global)
    end
end

function Keybinds.connectForGlobal(keybinds)
    table.merge(Keybinds.global, keybinds)
    Keybinds.refresh(false)
end

function Keybinds.connectForClient(keybinds)
    table.merge(Keybinds.client, keybinds)
end

function Keybinds.connectForMacro(keybinds)
    table.merge(Keybinds.macros, keybinds)
end