local beautiful = require("beautiful")
local awful = require("awful")

--- Iterates over list of clients to apply border width
--- @param clients table table of clients to iterate over
local function apply_border(clients)
    for _, v in pairs(clients) do
        v.border_width = beautiful.border_width
    end
end

--- Iterates over list of clients to remove border
--- @param clients table table of clients to iterate over
local function remove_border(clients)
    for _, c in pairs(clients) do
        c.border_width = 0
    end
end



client.connect_signal("manage", function(c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
    -- TODO Why is this here? And why border color does not change automatically?
    c.border_color = beautiful.border_focus

    -- TODO Need to add handling when multiple tags are present at the same time
    local tags = c:tags()
    local clients = tags[1]:clients()

    if #clients > 1 then
        apply_border(clients)
    elseif #clients <= 1 then
        remove_border(clients)
    end

end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)