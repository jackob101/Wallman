return {
	"folke/tokyonight.nvim",
	priority = 200,
	config = function()
		require("tokyonight").setup()
		vim.cmd([[colorscheme tokyonight-moon]])

	end,
}
