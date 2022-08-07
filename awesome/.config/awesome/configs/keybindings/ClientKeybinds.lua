return function()
    Keybinds.connectForGlobal(Gears.table.join(
            Awful.key({ ModKey }, "k", function()
                Awful.client.focus.byidx(1)
            end, { description = "focus next by index", group = "client" }),

            Awful.key({ ModKey }, "j", function()
                Awful.client.focus.byidx(-1)
            end, { description = "focus previous by index", group = "client" }),

            Awful.key({ ModKey, "Shift" }, "k", function()
                Awful.client.swap.byidx(1)
            end, { description = "swap with next client by index", group = "client" }),

            Awful.key({ ModKey, "Shift" }, "j", function()
                Awful.client.swap.byidx(-1)
            end, { description = "swap with previous client by index", group = "client" }),

            Awful.key(
                    { ModKey },
                    "u",
                    Awful.client.urgent.jumpto,
                    { description = "jump to urgent client", group = "client" }
            ),

            Awful.key({ ModKey }, "Tab", function()
                Awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end, { description = "go back", group = "client" }),

            Awful.key({ ModKey, "Shift" }, "n", function()
                local c = Awful.client.restore()
                -- Focus restored client
                if c then
                    c:emit_signal("request::activate", "key.unminimize", { raise = true })
                end
            end, { description = "restore minimized", group = "client" })
    ))

    Keybinds.connectForClient(Gears.table.join(
            Awful.key({ ModKey }, "f", function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end, { description = "toggle fullscreen", group = "client" }),

            Awful.key({ ModKey, "Shift" }, "q", function(c)
                c:kill()
            end, { description = "close", group = "client" }),

            Awful.key(
                    { ModKey, "Control" },
                    "space",
                    Awful.client.floating.toggle,
                    { description = "toggle floating", group = "client" }
            ),

            Awful.key({ ModKey, "Control" }, "Return", function(c)
                c:swap(Awful.client.getmaster())
            end, { description = "move to master", group = "client" }),
            Awful.key({ ModKey }, "s", function()
                local focused_screen = Awful.screen.focused()
                local focused_screen_clients = focused_screen.selected_tag:clients()

                local next_screen_index = (focused_screen.index % 2) + 1
                local next_screen = screen[next_screen_index]
                local next_screen_clients = next_screen.selected_tag:clients()

                for _, c in ipairs(next_screen_clients) do
                    c:move_to_screen(focused_screen)
                end

                for _, c in ipairs(focused_screen_clients) do
                    c:move_to_screen(next_screen)
                end
            end, { description = "Switch currently focused clients between screens", group = "client" }),
            Awful.key({ ModKey }, "t", function(c)
                c.ontop = not c.ontop
            end, { description = "toggle keep on top", group = "client" }),
            Awful.key({ ModKey }, "n", function(c)
                c.minimized = true
            end, { description = "minimize", group = "client" }),

            Awful.key({ ModKey }, "m", function(c)
                --c.maximized = not c.maximized
                --c:raise()
                c:maximize()
            end, { description = "(un)maximize", group = "client" })
    ))
end
