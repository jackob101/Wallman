return {
	"ms-jpq/coq_nvim",
	branch = "coq",
	config = function()
		vim.g.coq_settings = {
			auto_start = true,
		}
		require("coq")
	end,
}
