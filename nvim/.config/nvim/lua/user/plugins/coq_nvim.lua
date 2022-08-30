return {

	branch = "coq",
	config = function()
		vim.g.coq_settings = {
			auto_start = true,
			keymap = {
				jump_to_mark = "",
			},
		}
		require("coq")
	end,
}
