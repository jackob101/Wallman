return {

	after = "mason.nvim",
	config = function()
		require("mason-lspconfig").setup()
	end,
}
