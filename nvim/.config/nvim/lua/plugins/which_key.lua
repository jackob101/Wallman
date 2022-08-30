return {
	config = function()
		local wk = require("which-key")
		wk.setup()

		wk.register({
			["<C-n>"] = { "<cmd>NvimTreeToggle<CR>", "Toggle file explorer" },
			["<A-i>"] = { "<cmd>ToggleTerm <CR>", "Toggle terminal" },
			["<A-h>"] = { "<cmd>lua _HORIZONTAL_TERMINAL_TOGGLE()<cr>", "Toggle horizontal terminal" },
			["<A-v>"] = { "<cmd>3ToggleTerm size=100 direction=vertical<cr>", "Toggle vertical terminal" },
			["<leader>w"] = { "<cmd>w<cr>", "Save buffer" },
			["<leader>q"] = { "<cmd>q<cr>", "Quit buffer" },
			["<leader>f"] = {
				name = "File",
				f = { "<cmd>Telescope find_files<cr>", "Find File" },
			},
			["<leader>s"] = {
				name = "Search/Jump",
				f = {
					"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>",
					"HOP after cursor",
				},
				F = {
					"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>",
					"HOP before cursor",
				},
			},
			["<leader>l"] = {
				name = "LSP",
				p = { "<cmd> lua vim.diagnostic.goto_prev()<cr>", "Go to previous error" },
				n = { "<cmd> lua vim.diagnostic.goto_next()<cr>", "Go to next error" },
				f = { "<cmd>lua vim.lsp.diagnostic.open_float()<cr>", "Show diagnostics in floating window" },
			},
			["<leader>b"] = {
				name = "Buffers",
				cl = {
					"<cmd>BufferLineCloseLeft<cr>",
					"Close buffers to the left",
				},
				cr = {
					"<cmd>BufferLineCloseRight<cr>",
					"Close buffers to the right",
				},
			},

			["<leader>g"] = {
				name = "GIT",
				g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Open Lazy Git" },
			},
		})

		wk.register({
			["<A-i>"] = { "<cmd>ToggleTerm <CR>", "Toggle terminal" },
			["<A-h>"] = { "<cmd>lua _HORIZONTAL_TERMINAL_TOGGLE()<cr>", "Toggle horizontal terminal" },
			["<A-v>"] = { "<cmd>3ToggleTerm<cr>", "Toggle vertical terminal" },
		}, { mode = "t" })

		function _LSP_ATTACH(_, bufnr)
			local bufopt = { noremap = true, silent = true, buffer = bufnr }

			wk.register({
				["<C-p>"] = { " <cmd>lua vim.lsp.buf.signature_help(bufopt)<cr>", "Signature help" },
				["<leader>l"] = {
					name = "LSP",
					g = {
						name = "Goto",
						gD = { "<cmd>lua vim.lsp.buf.declaration(bufopt)<cr>", "Go to declaration" },
						gd = { " <cmd>lua vim.lsp.buf.definition(bufopt)<cr>", "Go to definition" },
						gi = { " <cmd>lua vim.lsp.buf.implementation(bufopt)<cr>", "Go to implementation" },
						gr = { " <cmd>lua vim.lsp.buf.references(bufopt)<cr>", "Go to references" },
					},
					h = { " <cmd>lua vim.lsp.buf.hover(bufopt)<cr>", "Show hover" },
					d = { "<cmd>lua  vim.lsp.buf.type_definition(bufopt)<cr>", "Type definition" },
					r = { " <cmd>lua vim.lsp.buf.rename(bufopt)<cr>", "Rename" },
					a = { " <cmd>lua vim.lsp.buf.code_action(bufopt)<cr>", "Code actions" },
					f = { " <cmd>lua vim.lsp.buf.formatting(bufopt)<cr>", "Format" },
				},
			})
		end
	end,
}
