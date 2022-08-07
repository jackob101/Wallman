local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local wallpaper_folder = os.getenv("HOME") .. "/Wallpapers"
local wallpaper = gears.filesystem.get_random_file_from_dir(wallpaper_folder)
-- Create a wibox for each screen and add it
local function set_wallpaper(s)
	-- Wallpaper
	Awful.wallpaper({
		screen = s,
		widget = {
			image = wallpaper_folder .. "/" .. wallpaper,
			resize = true,
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
			widget = wibox.widget.imagebox,
		},
	})
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)
end)
-- }}}
