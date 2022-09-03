return {

	branch = "coq",
	config = function()
		vim.g.coq_settings = {
			auto_start = true,
			keymap = {
				jump_to_mark = "<A-TAB>",
			},
			clients = {
				lsp = {
					weight_adjust = 1.4,
					resolve_timeout = 0.5,
				},
			},
		}
		require("coq")
	end,
}
