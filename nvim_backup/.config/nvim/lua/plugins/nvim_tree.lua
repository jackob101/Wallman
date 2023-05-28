return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- optional, for file icons
	},
	config = function()
		require("nvim-tree").setup({
			diagnostics = {
				enable = true,
			},
			view = {
				width = 35,
			},
			renderer = {
				root_folder_label = false,
				indent_markers = {
					enable = false,
				},
			},
		})
	end,
}
