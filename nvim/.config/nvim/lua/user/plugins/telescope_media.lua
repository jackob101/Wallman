return {
	after = "telescope.nvim",
	config = function()
		require("telescope").load_extension("media_files")
	end,
}
