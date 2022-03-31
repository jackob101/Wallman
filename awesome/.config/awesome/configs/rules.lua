local awful = require("awful")
local beautiful = require("beautiful")
local clientkeys = require("configs.keys.keybinds").clientkeys
local clientbuttons = require("configs.clientbuttons")

local twoScreens = screen:count() == 2

-- client.connect_signal("property::floating", function(c)
-- 	if c.floating then
-- 		awful.titlebar.show(c)
-- 	else
-- 		awful.titlebar.hide(c)
-- 	end
-- end)

-- client.connect_signal("manage", function(c)
-- 	if c.floating or c.first_tag.layout.name == "floating" then
-- 		awful.titlebar.show(c)
-- 	else
-- 		awful.titlebar.hide(c)
-- 	end
-- end)

-- tag.connect_signal("property::layout", function(t)
-- 	local clients = t:clients()
-- 	for k, c in pairs(clients) do
-- 		if c.floating or c.first_tag.layout.name == "floating" then
-- 			awful.titlebar.show(c)
-- 		else
-- 			awful.titlebar.hide(c)
-- 		end
-- 	end
-- end)

awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			titlebars_enabled = false,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
		callback = awful.client.setslave,
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
				"awakened-poe-trade",
				"Pavucontrol",
				"Thunar",
			},
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true, placement = awful.placement.centered },
	},
	{
		rule = {
			class = "Thunar",
		},
		properties = {
			width = 1000,
			height = 800,
		},
	},

	{
		rule = {
			class = "discord",
		},
		properties = {
			tag = "10",
			screen = twoScreens and 2 or 1,
		},
	},
	{
		rule = {
			class = "TelegramDesktop",
		},
		properties = {
			tag = "9",
			screen = twoScreens and 2 or 1,
		},
	},
	{
		rule = {
			name = "Spotify",
		},
		properties = {
			tag = "8",
			screen = twoScreens and 2 or 1,
		},
	},
}
