local M = {}

M.additional_mappings = {
	n = {
		["<A-CR>"] = { "<cmd>s/$/;/ | noh<cr>", "Append ;" },
		["<leader>te"] = { "<cmd>NvimTreeToggle<cr>", "Toggle file explorer" },
		["<leader>fs"] = { "<cmd>w<cr>", "Save current buffer" },
		["<leader>f<S-s>"] = { "<cmd>wa<cr>", "Save all buffers" },
		["<leader>mp"] = { "<cmd>lua require('nvim-window').pick()<cr>", "Pick window" },
	},
	i = {
		["<A-CR>"] = { "<cmd>s/$/;/ | noh<cr>", "Append ;" },
	},
}

M.lazygit = {
	n = {
		["<leader>gg"] = { "<cmd>LazyGit<cr>", "Open lazy git" },
	},
}

M.lsp_custom = {
	plugin = true,
	n = {
		["<C-x>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Toggle signature help" },
		["gr"] = { "<cmd>Telescope lsp_references<cr>", "Go to references" },
		["<F2>"] = {
			"<cmd>lua vim.diagnostic.goto_next({severity=vim.diagnostic.severity.ERROR})<cr>",
			"Go to next error",
		},
		["<leader>d"] = {
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			"Show current buffer diagnostics",
		},
	},
	i = {
		["<C-x>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Toggle signature help" },
	},
}

M.lspconfig = {
	n = {

		["<leader>f"] = {
			function()
				vim.diagnostic.open_float({ border = "single" })
			end,
			"Floating diagnostic",
		},

		["[d"] = {
			function()
				vim.diagnostic.goto_prev({ float = { border = "single" } })
			end,
			"Goto prev",
		},

		["]d"] = {
			function()
				vim.diagnostic.goto_next({ float = { border = "single" } })
			end,
			"Goto next",
		},
	},
}

M.hop = {
	n = {
		["<leader>j"] = {
			"<cmd>HopChar2<cr>",
			"Hop",
		},
	},
}

M.trouble = {
	plugin = true,
	n = {
		["<leader>q"] = {
			"<cmd>TroubleToggle document_diagnostics<cr>",
			"Document diagnostics",
		},
	},
}

M.outline = {
	plugin = true,
	n = {
		["<leader>o"] = {
			"<cmd>SymbolsOutline<cr>",
			"Lsp Outline",
		},
	},
}

return M
