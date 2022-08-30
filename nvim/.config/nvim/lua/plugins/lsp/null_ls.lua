return {

	config = function()
		local null_ls = require("null-ls")
		local b = null_ls.builtins

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			debug = true,
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
							vim.lsp.buf.formatting_sync()
						end,
					})
				end
			end,
			sources = {
				-- Lua
				b.formatting.stylua,

				-- Shell
				-- b.formatting.shfmt,
				-- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

				-- Rust
				b.formatting.rustfmt,

				-- Json
				b.formatting.jq,
			},
		})
	end,
}
