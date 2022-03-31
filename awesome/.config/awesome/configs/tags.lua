local awful = require("awful")
local icons = require("icons")

local conf = {
	{
		{
			name = "Web",
			icon_widget = icons.planet.widget,
			only_icon = true,
		},
		{
			name = "Terminal",
			icon_widget = icons.terminal.widget,
			only_icon = true,
		},
		{
			name = "Code",
			icon_widget = icons.code_tags.widget,
			only_icon = true,
		},
		{
			name = "4",
		},
		{
			name = "5",
		},
		{
			name = "6",
		},
		{
			name = "7",
		},
		{
			name = "8",
		},
		{
			name = "9",
		},
		{
			name = "0",
		},
	},
	{
		{
			name = "1",
		},
		{
			name = "2",
		},
		{
			name = "3",
		},
		{
			name = "4",
		},
		{
			name = "5",
		},
		{
			name = "6",
		},
		{
			name = "7",
		},
		{
			name = "Spotify",
			icon_widget = icons.spotify.widget,
			only_icon = true,
		},
		{
			name = "Telegram",
			icon_widget = icons.telegram.widget,
			only_icon = true,
		},
		{
			name = "Discord",
			icon_widget = icons.discord.widget,
			only_icon = true,
		},
	},
}

screen.connect_signal("request::desktop_decoration", function(s)
	if conf[s.index] ~= nil then
		for i, t in ipairs(conf[s.index]) do
			awful.tag.add(i, {
				icon_only = false,
				screen = s,
				icon_widget = t.icon_widget,
				layout = awful.layout.suit.tile,
				selected = i == 1,
				only_icon = t.only_icon,
			})
		end
	else
		for i = 1, 10 do
			awful.tag.add(i, {
				screen = s,
				layout = awful.layout.suit.tile,
				selected = i == 1,
			})
		end
	end
end)
