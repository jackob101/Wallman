return {
	tag = "v2.*",
	config = function()
		require("toggleterm").setup()

		local Terminal = require("toggleterm.terminal").Terminal
		--
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
		})

		local horizontal_terminal = Terminal:new({
			hidden = true,
			size = 20,
			direction = "horizontal",
		})

		local vertical_terminal = Terminal:new({
			hidden = true,
			size = 30,
			direction = "vertical",
		})

		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		function _VERTICAL_TERMINAL_TOGGLE()
			vertical_terminal:toggle()
		end

		function _HORIZONTAL_TERMINAL_TOGGLE()
			horizontal_terminal:toggle()
		end
	end,
}
