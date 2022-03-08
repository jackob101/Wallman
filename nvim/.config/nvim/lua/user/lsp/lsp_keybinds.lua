local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

local M = {}
function M.register_keybinds(bufnr)
	local opts = {
		buffer = bufnr,
		prefix = "<leader>",
	}
	wk.register({
		l = {
			name = "Lsp",
			f = {
				":lua vim.lsp.buf.formatting_sync()<cr>",
				"Format buffer",
			},
			h = {
				":lua vim.lsp.buf.signature_help()<cr>",
				"Show documentations",
			},
			a = {
				":Telescope lsp_code_actions theme=dropdown<cr>",
				"Show code actions",
			},
			k = {
				":lua vim.lsp.buf.hover()<cr>",
				"Show on hover",
			},
			r = {
				":lua vim.lsp.buf.rename()<cr>",
				"Rename variable",
			},
			D = {
				":Telescope diagnostics bufnr=0 theme=ivy<cr>",
				"Show list of Diagnostics",
			},
			t = {
				":Trouble<cr>",
				"Toggle trouble",
			},
			d = {
				name = "Diagnostics",
				o = {
					":lua vim.diagnostic.open_float({border = 'rounded'})<cr>",
					"Open Diagnostics",
				},
				p = {
					": lua vim.diagnostic.goto_prev({ border = 'rounded'})<CR>",
					"Previous diagnostic",
				},
				n = {
					":lua vim.diagnostic.goto_next({border = 'rounded'})<cr>",
					"Next Diagnostics",
				},
			},
			i = {
				":lua vim.lsp.buf.implementation()<cr>",
				"Go to implementation",
			},
			g = {
				name = "Go to",
				D = {
					":lua vim.lsp.buf.declaration()<cr>",
					"Go to declaration",
				},
				d = {
					":Telescope lsp_definitions theme=ivy<cr>",
					"Show definitions",
				},
				r = {
					":Telescope lsp_references theme=ivy<cr>",
					"Go to references",
				},
			},
		},
	}, opts)
end

return M
