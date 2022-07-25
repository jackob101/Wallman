----------------------------------------
-- Initialize basic configs
----------------------------------------
load_all("configs", { "layouts", "titlebar", "tags", "wallpaper", "client", "keybinds_init" })
----------------------------------------

-- Initialize keybinds
----------------------------------------
require("awful.hotkeys_popup.keys")
