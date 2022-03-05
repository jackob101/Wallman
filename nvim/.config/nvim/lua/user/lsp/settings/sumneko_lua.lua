return {
	settings = {

		Lua = {
			diagnostics = {
				globals = { "vim", "client", "screen" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
