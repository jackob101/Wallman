return {
	"folke/which-key.nvim",
	config = function()
		local wk = require("which-key")
		wk.setup()

		wk.register({
			["<C-n>"] = { "<cmd>NvimTreeToggle<CR>", "Toggle file explorer" },
		})
	end,
}
