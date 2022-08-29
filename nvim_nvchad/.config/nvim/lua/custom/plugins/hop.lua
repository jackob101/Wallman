return {
	branch = "v2",
	config = function()
		print("Testing")
		require("hop").setup({
			keys = "etovxqpdygfblzhckisuran",
		})
	end,
}
