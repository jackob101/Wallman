local awful = require("awful")
local gears = require("gears")

local function press_button (button)
  root.fake_input('key_press',   button)
  root.fake_input('key_release', button)
end

local pop_flasks = function ()
  press_button("2")
  press_button("3")
  press_button("4")
  press_button("5")
end

local function mouse_button_press (button_id, x, y)

    root.fake_input("button_press", button_id)
    root.fake_input("button_release", button_id)

end

local macro_keybinds = gears.table.join(
  -- awful.key(
  --   {},
  --   "s",
  --   nil,
  --   function ()
  --     pop_flasks()
  --   end,
  --   { description = "Pop flask from slot 2-4", group = "Macros" }
  -- ),
  awful.key(
    {},
    "F1",
    function ()
      mouse_button_press(1)
    end,
    { description = "Spam click LMB", group = "Macros" }
  ),
  awful.key(
    {"Shift"},
    "F1",
    function ()
      root.fake_input("key_press", "Shift_L")
      mouse_button_press(1)
    end,
    function ()
      root.fake_input("key_release", "Shift_L")
    end,
    { description = "Spam click Shift + LMB", group = "Macros" }
  ),
  awful.key(
    {"Ctrl"},
    "F1",
    function ()
      root.fake_input("key_press", "Control_L")
      mouse_button_press(1)
    end,
    function ()
      root.fake_input("key_release", "Control_L")
    end,
    { description = "Spam click Control + LMB", group = "Macros" }
  )
)

return macro_keybinds
