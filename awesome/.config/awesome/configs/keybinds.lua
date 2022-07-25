local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local modkey = require("configs.mod").modkey
local client_mover = require("modules.client_mover")

require("awful.hotkeys_popup.keys")

local function press_button(button)
	root.fake_input("key_press", button)
	root.fake_input("key_release", button)
end

local function pop_flasks()
	press_button("2")
	press_button("3")
	press_button("4")
	press_button("5")
end

local function mouse_button_press(button_id, _, _)
	root.fake_input("button_press", button_id)
	root.fake_input("button_release", button_id)
end

local keys = {}

-- stylua: ignore start
keys.globalkeys = gears.table.join(
	--  █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
	-- ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
	-- ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗  
	-- ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝  
	-- ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
	-- ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

	awful.key(
		{ modkey },
		"F1",
		hotkeys_popup.show_help,
		{ description = "show help", group = "awesome" }
	),

	awful.key(
		{ modkey, "Shift" },
		"r",
		awesome.restart,
		{ description = "reload awesome", group = "awesome" }
	),

	awful.key(
		{ modkey, "Shift", "Control" },
		"l",
		awesome.quit,
		{ description = "quit awesome", group = "awesome" }
	),
	awful.key(
		{ modkey, "Shift", "Control" },
		"t",
		function ()
			awesome.emit_signal("modules::dnd:toggle")
		end,
		{ description = "toggle Do not disturb mode", group = "awesome" }
	),
	awful.key(
		{modkey, "Shift", "Control"},
		"m",
		function ()
			awesome.emit_signal("macros::toggle")
		end,
		{ description = "Toggle macros", group = "awesome" }
	),

	awful.key(
		{modkey },
		"c",
		function ()
			awful.screen.focused().central_panel:toggle()
		end,
		{ description = "Toggle notification panel", group = "awesome" }
	),

	--  ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
	-- ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
	-- ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║
	-- ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║
	-- ╚██████╗███████╗██║███████╗██║ ╚████║   ██║
	--  ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝

	awful.key(
		{ modkey },
		"k",
		function() awful.client.focus.byidx(1) end,
		{ description = "focus next by index", group = "client"}
	),

	awful.key(
		{ modkey },
		"j",
		function() awful.client.focus.byidx(-1) end,
		{ description = "focus previous by index", group = "client", }
	),

	awful.key(
		{ modkey, "Shift" },
		"k",
		function() awful.client.swap.byidx(1) end,
		{ description = "swap with next client by index", group = "client", }
	),

	awful.key(
		{ modkey, "Shift" },
		"j",
		function() awful.client.swap.byidx(-1) end,
		{ description = "swap with previous client by index", group = "client", }
	),

	awful.key(
		{ modkey },
		"u",
		awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }
	),

	awful.key(
		{ modkey },
		"Tab",
		function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{ description = "go back", group = "client", }
	),

	awful.key(
		{ modkey, "Shift" },
		"n",
		function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end,
		{ description = "restore minimized", group = "client", }
	),


	-- ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗ 
	-- ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
	-- ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
	-- ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
	-- ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
	-- ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

	awful.key(
		{ modkey },
		"Return",
		function() awful.spawn(terminal) end,
		{ description = "open a terminal", group = "launcher", }
	),

	awful.key(
		{ modkey },
		"r",
		function() awful.screen.focused().mypromptbox:run() end,
		{ description = "run prompt", group = "launcher", }
	),

	awful.key(
		{ modkey },
		"d",
		function() awful.spawn(os.getenv("HOME") .. "/.config/rofi/launcher.sh") end,
		{ description = "Run rofi", group = "launcher" }
	),

	awful.key(
		{ modkey, "Shift" },
		"e",
		function() awesome.emit_signal('module::exit_screen:show') end,
		{ description = "Run power menu", group = "launcher" }
	),
	awful.key(
		{ modkey, "Shift" },
		"c",
		function() awful.spawn("rofi -show calc -modi calc -no-show-match -no-sort -theme " .. os.getenv("HOME") .. "/.config/rofi/calc.rasi") end,
		{ description = "Spawn calculator", group = "launcher" }
	),
	awful.key(
		{ modkey },
		"e",
		function() awful.spawn("emacsclient -c -a 'emacs'") end,
		{ description = "Spawn emacs", group = "launcher" }
	),
	awful.key(
			{ modkey, "Ctrl"},
			"d",
			function()
				awesome.emit_signal("dashboard::toggle")
			end,
			{
				description = "Open dashboard",
				group = "launcher"
			}
	),
	-- ██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗
	-- ██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝
	-- ██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║
	-- ██║     ██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ██║
	-- ███████╗██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ██║
	-- ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ╚═╝

	awful.key(
		{ modkey },
		"l",
		function() awful.tag.incmwfact(0.05) end,
		{ description = "increase master width factor", group = "layout", }
	),

	awful.key(
		{ modkey },
		"h",
		function() awful.tag.incmwfact(-0.05) end,
		{ description = "decrease master width factor", group = "layout", }
	),

	awful.key(
		{ modkey, "Shift" },
		"h",
		function() awful.tag.incnmaster(1, nil, true) end,
		{ description = "increase the number of master clients", group = "layout", }
	),

	awful.key(
		{ modkey, "Shift" },
		"l",
		function() awful.tag.incnmaster(-1, nil, true) end,
		{ description = "decrease the number of master clients", group = "layout", }
	),

	awful.key(
		{ modkey, "Control" },
		"h",
		function() awful.tag.incncol(1, nil, true) end,
		{ description = "increase the number of columns", group = "layout", }
	),

	awful.key(
		{ modkey, "Control" },
		"l",
		function() awful.tag.incncol(-1, nil, true) end,
		{ description = "decrease the number of columns", group = "layout", }
	),

	awful.key(
		{ modkey },
		"space",
		function() 
			awful.layout.inc(1) end,
		{ description = "select next", group = "layout", }
	),

	awful.key(
		{ modkey, "Shift" },
		"space",
		function() awful.layout.inc(-1) end,
		{ description = "select previous", group = "layout", }
	),

	-- ████████╗ █████╗  ██████╗
	-- ╚══██╔══╝██╔══██╗██╔════╝
	--    ██║   ███████║██║  ███╗
	--    ██║   ██╔══██║██║   ██║
	--    ██║   ██║  ██║╚██████╔╝
	--    ╚═╝   ╚═╝  ╚═╝ ╚═════╝

	awful.key(
		{ modkey },
		"Left",
		awful.tag.viewprev,
		{ description = "view previous", group = "tag" }
	),

	awful.key(
		{ modkey },
		"Right",
		awful.tag.viewnext,
		{ description = "view next", group = "tag" }
	),

	awful.key(
		{ modkey },
		"Escape",
		awful.tag.history.restore,
		{ description = "go back", group = "tag" }
	),

	-- ███████╗ ██████╗██████╗ ███████╗███████╗███╗   ██╗
	-- ██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║
	-- ███████╗██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║
	-- ╚════██║██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║
	-- ███████║╚██████╗██║  ██║███████╗███████╗██║ ╚████║
	-- ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝

	awful.key(
		{ modkey, "Control" },
		"j",
		function() awful.screen.focus_relative(1) end,
		{ description = "focus the next screen", group = "screen", }
	),

	awful.key(
		{ modkey, "Control" },
		"k",
		function() awful.screen.focus_relative(-1) end,
		{ description = "focus the previous screen", group = "screen", }
	),

	awful.key(
		{ },
		"Print",
		function() awful.spawn("flameshot gui") end,
		{ description = "Print screen", group = "screen", }
	),
	--  █████╗ ██╗   ██╗██████╗ ██╗ ██████╗ 
	-- ██╔══██╗██║   ██║██╔══██╗██║██╔═══██╗
	-- ███████║██║   ██║██║  ██║██║██║   ██║
	-- ██╔══██║██║   ██║██║  ██║██║██║   ██║
	-- ██║  ██║╚██████╔╝██████╔╝██║╚██████╔╝
	-- ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ 

	awful.key(
		{  },
		"XF86AudioRaiseVolume",
		function()
			awesome.emit_signal('module::volume:up', true)
		end,
		{description="Increase volume", group = "audio"}
	),

	awful.key(
		{  },
		"XF86AudioLowerVolume",
		function()
			awesome.emit_signal('module::volume:down', true)
		end,
		{description = "Descrease volume", group = "audio"}
	),

	awful.key(
		{  },
		"XF86AudioMute",
		function() awesome.emit_signal('module::volume:toggle') end,
		{description = "Mute audio", group = "audio"}
	),

	-- ███████╗██╗   ██╗███████╗████████╗██████╗  █████╗ ██╗   ██╗
	-- ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚██╗ ██╔╝
	-- ███████╗ ╚████╔╝ ███████╗   ██║   ██████╔╝███████║ ╚████╔╝ 
	-- ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══██╗██╔══██║  ╚██╔╝  
	-- ███████║   ██║   ███████║   ██║   ██║  ██║██║  ██║   ██║   
	-- ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝  

	awful.key(
		{ modkey },
		"=",
		function()
			awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
		end,
		{description = "Toggle systray", group="systray"}
	)
)

-- ████████╗ █████╗  ██████╗ ███████╗
-- ╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝
--    ██║   ███████║██║  ███╗███████╗
--    ██║   ██╔══██║██║   ██║╚════██║
--    ██║   ██║  ██║╚██████╔╝███████║
--    ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝

for i = 1, 10 do
	keys.globalkeys = gears.table.join(
		keys.globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
		end, {
				description = "view tag #" .. i,
				group = "tag",
		}),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
		end, {
				description = "toggle tag #" .. i,
				group = "tag",
		}),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
		end, {
				description = "move focused client to tag #" .. i,
				group = "tag",
		}),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
		end, {
				description = "toggle focused client on tag #" .. i,
				group = "tag",
		})
	)
end

-- ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
--██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
--██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   
--██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   
--╚██████╗███████╗██║███████╗██║ ╚████║   ██║   
-- ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   

keys.clientkeys = gears.table.join(
	awful.key(
		{ modkey },
		"f",
		function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{ description = "toggle fullscreen", group = "client", }
	),

	awful.key(
		{ modkey, "Shift" },
		"q",
		function(c) c:kill() end,
		{ description = "close", group = "client" }),

	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),

	awful.key(
		{ modkey, "Control" },
		"Return",
		function(c) c:swap(awful.client.getmaster()) end,
		{ description = "move to master", group = "client", }
	),
	awful.key(
		{modkey},
		"s",
		function ()
			local focused_screen = awful.screen.focused()
			local focused_screen_clients = focused_screen.selected_tag:clients()

			local next_screen_index = (focused_screen.index % 2) + 1
			local next_screen = screen[next_screen_index]
			local next_screen_clients = next_screen.selected_tag:clients()

			for _,c in ipairs(next_screen_clients) do
				c:move_to_screen(focused_screen)
			end

			for _,c in ipairs(focused_screen_clients) do
				c:move_to_screen(next_screen)
			end

		end,
		{description = "Switch currently focused clients between screens", group = "client"}
	),
	awful.key(
		{ modkey },
		"o",
		function (c)
			client_mover(c)
		end
	),
	awful.key(
		{ modkey },
		"t",
		function(c) c.ontop = not c.ontop end,
		{ description = "toggle keep on top", group = "client", }
	),
	awful.key(
		{ modkey },
		"n",
		function(c) c.minimized = true end,
		{ description = "minimize", group = "client", }
	),

	awful.key(
		{ modkey },
		"m",
		function(c)
			--c.maximized = not c.maximized
			--c:raise()
			c:maximize()
		end,
		{ description = "(un)maximize", group = "client", }
	)

)
keys.macro_keybinds = gears.table.join(
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
-- Stylua:ignore end

root.keys(keys.globalkeys)


return keys 
