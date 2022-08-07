-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
require("awful.autofocus")

require("preInit")

require("utils")

require("configs.keybindings")
Keybinds.init()

require("icons")
IconsHandler.init()

load_all("", {
    "configs",
    "layout",
    "errors",
})

require("services")


require("widgets")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

Menubar.utils.terminal = terminal -- Set the terminal for applications that require it



VolumeService.update()
