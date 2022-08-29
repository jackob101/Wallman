return {
	"kyazdani42/nvim-tree.lua",
	requires = {
		"kyazdani42/nvim-web-devicons", -- optional, for file icons
	},
	config = function()
		require("nvim-tree").setup()
	end,
}
