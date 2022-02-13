local macros = require("configs.keys.macros")
local keybinds = require("configs.keys.keybinds")
local gears = require("gears")
local naughty = require("naughty")
local icons = require("icons.init")

local are_macros_on = false
local macros_and_keybinds = gears.table.join(macros,keybinds)

local function refresh_keybinds()

  if are_macros_on then
    naughty.notify ({
      title = "Macros",
      message = "Turned ON!",
      icon = icons.macros,
    })
    root.keys(macros_and_keybinds)
  else
    naughty.notify ({
      title = "Macros",
      message = "Turned OFF!",
      icon = icons.macros,
    })
    root.keys(keybinds)
  end

  awesome.emit_signal("macros::update", are_macros_on)

end

local toggle_macros = function ()

  are_macros_on = not are_macros_on
  refresh_keybinds()

end

refresh_keybinds()

awesome.connect_signal("macros::toggle", toggle_macros)
