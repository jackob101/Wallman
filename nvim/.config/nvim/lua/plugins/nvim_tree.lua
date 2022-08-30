return {

	requires = {
		"kyazdani42/nvim-web-devicons", -- optional, for file icons
	},
	config = function()
		require("nvim-tree").setup({
			diagnostics = {
				enable = true,
			},
		})
	end,
}
