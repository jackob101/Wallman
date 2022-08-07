local function createDesc(text, index)
    if index == 1 then
        return {
            description = text,
            group = "tag",
        }
    end
end

return function()

    local newKeys = Gears.table.join(
            Awful.key(
                    { ModKey },
                    "Left",
                    Awful.tag.viewprev,
                    { description = "view previous", group = "tag" }
            ),

            Awful.key(
                    { ModKey },
                    "Right",
                    Awful.tag.viewnext,
                    { description = "view next", group = "tag" }
            ),

            Awful.key(
                    { ModKey },
                    "Escape",
                    Awful.tag.history.restore,
                    { description = "go back", group = "tag" }
            )

    )

    for i = 1, 10 do
        newKeys = Gears.table.join(
                newKeys,
                Awful.key({ ModKey }, "#" .. i + 9, function()
                    local screen = Awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        tag:view_only()
                    end
                end, createDesc("View tag with number 1-10", i)),
        -- Toggle tag display.
                Awful.key({ ModKey, "Control" }, "#" .. i + 9, function()
                    local screen = Awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        Awful.tag.viewtoggle(tag)
                    end
                end, createDesc("Toggle tag with number 1-10", i)),
        -- Move client to tag.
                Awful.key({ ModKey, "Shift" }, "#" .. i + 9, function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                    end
                end, createDesc("Move focused client to tag 1-10", i)),
        -- Toggle tag on focused client.
                Awful.key({ ModKey, "Control", "Shift" }, "#" .. i + 9, function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end, createDesc("Toggle focused client on tag 1-10", i))
        )
    end

    Keybinds.connectForGlobal(newKeys)
end
