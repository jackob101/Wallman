local hotkeys_popup = require("awful.hotkeys_popup")

return function()

    Keybinds.connectForGlobal(Gears.table.join(
            Awful.key(
                    { ModKey },
                    "F1",
                    hotkeys_popup.show_help,
                    { description = "show help", group = "awesome" }
            ),

            Awful.key(
                    { ModKey, "Shift" },
                    "r",
                    awesome.restart,
                    { description = "reload awesome", group = "awesome" }
            ),

            Awful.key(
                    { ModKey, "Shift", "Control" },
                    "l",
                    awesome.quit,
                    { description = "quit awesome", group = "awesome" }
            ),

            Awful.key(
                    { ModKey },
                    "c",
                    function()
                        Awful.screen.focused().central_panel:toggle()
                    end,
                    { description = "Toggle notification panel", group = "awesome" }
            )
    ))

end