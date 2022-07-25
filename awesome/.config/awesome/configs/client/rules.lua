local awful = require("awful")
local beautiful = require("beautiful")
local clientkeys = require("configs.keybinds").clientkeys
local clientbuttons = require("configs.client.buttons")

local twoScreens = screen:count() == 2

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = 0,
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
                --"awakened-poe-trade",
                "Thunar",
                "Xsane",
            },
            name = {
                "Event Tester", -- xev.
                "JetBrains Toolbox"
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
        rule_any = {
            class ={
                "Pavucontrol",
            }
        },
        properties = {
            floating = true,
            width = 960,
            height = 740,
            placement = awful.placement.centered,
        }
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
            tag = "0",
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
