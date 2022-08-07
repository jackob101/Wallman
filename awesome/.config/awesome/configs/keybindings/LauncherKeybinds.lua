return function()
	Keybinds.connectForGlobal(Gears.table.join(
		Awful.key({ ModKey }, "Return", function()
			Awful.spawn(terminal)
		end, { description = "open a terminal", group = "launcher" }),

		Awful.key({ ModKey }, "r", function()
			Awful.screen.focused().mypromptbox:run()
		end, { description = "run prompt", group = "launcher" }),

		Awful.key({ ModKey }, "d", function()
			Awful.spawn(os.getenv("HOME") .. "/.config/rofi/launcher.sh")
		end, { description = "Run rofi", group = "launcher" }),

		Awful.key({ ModKey, "Shift" }, "e", function()
			awesome.emit_signal("module::exit_screen:show")
		end, { description = "Run power menu", group = "launcher" }),
		Awful.key({ ModKey, "Shift" }, "c", function()
			Awful.spawn(
				"rofi -show calc -modi calc -no-show-match -no-sort -theme "
					.. os.getenv("HOME")
					.. "/.config/rofi/calc.rasi"
			)
		end, { description = "Spawn calculator", group = "launcher" }),
		Awful.key({ ModKey }, "e", function()
			Awful.spawn("emacsclient -c -a 'emacs'")
		end, { description = "Spawn emacs", group = "launcher" })
	))
end
