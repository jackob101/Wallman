return function()
    local newKeys = Gears.table.join(
            Awful.key(
                    { ModKey, "Control" },
                    "j",
                    function() Awful.screen.focus_relative(1) end,
                    { description = "focus the next screen", group = "screen", }
            ),

            Awful.key(
                    { ModKey, "Control" },
                    "k",
                    function() Awful.screen.focus_relative(-1) end,
                    { description = "focus the previous screen", group = "screen", }
            ),

            Awful.key(
                    { },
                    "Print",
                    function() Awful.spawn("flameshot gui") end,
                    { description = "Print screen", group = "screen", }
            )
    )

  Keybinds.connectForGlobal(newKeys)
end
