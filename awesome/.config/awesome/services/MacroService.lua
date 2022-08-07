--- @class MacroService : Initializable
--- @field isON boolean Tells if macros are turned on or not
--- @field toUpdate MacroUpdatable[] list of callback for update
MacroService = {
    isOn = false,
    isInitialized = false,
    toUpdate = {},
}

--- @return MacroService
function MacroService.init()

    MacroService._initKeybinds()
    MacroService.isInitialized = true
end

--- @param widget MacroUpdatable
function MacroService.connect(widget)
    table.insert(MacroService.toUpdate, widget)
end

function MacroService.toggle()

    if not MacroService.isInitialized then
        return
    end

    MacroService.isOn = not MacroService.isOn

    Keybinds.refresh(MacroService.isOn)

    if MacroService.isOn then
        Naughty.notify({
            title = "Macros",
            message = "Turned ON!",
            icon = IconsHandler.icons.macros.path,
            store = false,
        })
    else
        Naughty.notify({
            title = "Macros",
            message = "Turned OFF!",
            icon = IconsHandler.icons.macros.path,
            store = false,
        })
    end

    MacroService.update()
end

function MacroService.update()
    for _, v in ipairs(MacroService.toUpdate) do
        v:update(MacroService.isOn)
    end
end

function MacroService._keyPress(button)
    root.fake_input("key_press", button)
    root.fake_input("key_release", button)
end

function MacroService._mouseButtonClick(button_id, _, _)
    root.fake_input("button_press", button_id)
    root.fake_input("button_release", button_id)
end

function MacroService._initKeybinds()
    Keybinds.connectForGlobal(Gears.table.join(
            Awful.key(
                    { ModKey, "Shift", "Control" },
                    "m",
                    function()
                        MacroService.toggle()
                    end,
                    { description = "Toggle macros", group = "Macros" }
            )))

    Keybinds.connectForMacro(Gears.table.join(
            Awful.key(
                    {},
                    "`",
                    function()
                        MacroService._mouseButtonClick(1)
                    end,
                    { description = "Spam click LMB", group = "Macros" }
            ),
            Awful.key(
                    { "Shift" },
                    "`",
                    function()
                        root.fake_input("key_press", "Shift_L")
                        MacroService._mouseButtonClick(1)
                    end,
                    function()
                        root.fake_input("key_release", "Shift_L")
                    end,
                    { description = "Spam click Shift + LMB", group = "Macros" }
            ),
            Awful.key(
                    { "Ctrl" },
                    "`",
                    function()
                        root.fake_input("key_press", "Control_L")
                        MacroService._mouseButtonClick(1)
                    end,
                    function()
                        root.fake_input("key_release", "Control_L")
                    end,
                    { description = "Spam click Control + LMB", group = "Macros" }
            )

    ))

end
