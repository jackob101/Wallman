return {
	after = "nvim-lspconfig",
	config = function()
		require("illuminate").configure()
	end,
}
