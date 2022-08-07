return function()

    Keybinds.connectForGlobal(Gears.table.join(
            Awful.key(
                    { ModKey },
                    "l",
                    function() Awful.tag.incmwfact(0.05) end,
                    { description = "increase master width factor", group = "layout", }
            ),

            Awful.key(
                    { ModKey },
                    "h",
                    function() Awful.tag.incmwfact(-0.05) end,
                    { description = "decrease master width factor", group = "layout", }
            ),

            Awful.key(
                    { ModKey, "Shift" },
                    "h",
                    function() Awful.tag.incnmaster(1, nil, true) end,
                    { description = "increase the number of master clients", group = "layout", }
            ),

            Awful.key(
                    { ModKey, "Shift" },
                    "l",
                    function() Awful.tag.incnmaster(-1, nil, true) end,
                    { description = "decrease the number of master clients", group = "layout", }
            ),

            Awful.key(
                    { ModKey, "Control" },
                    "h",
                    function() Awful.tag.incncol(1, nil, true) end,
                    { description = "increase the number of columns", group = "layout", }
            ),

            Awful.key(
                    { ModKey, "Control" },
                    "l",
                    function() Awful.tag.incncol(-1, nil, true) end,
                    { description = "decrease the number of columns", group = "layout", }
            ),

            Awful.key(
                    { ModKey },
                    "space",
                    function()
                        Awful.layout.inc(1) end,
                    { description = "select next", group = "layout", }
            ),

            Awful.key(
                    { ModKey, "Shift" },
                    "space",
                    function() Awful.layout.inc(-1) end,
                    { description = "select previous", group = "layout", }
            )
    ))
end
