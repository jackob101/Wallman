local M = {}

M.lsp = {
	n = {
		["<leader>ld"] = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Show current buffer diagnostics" },
		["<leader>lD"] = { "<cmd>Telescope diagnostics<CR>", "Show current buffer diagnostics" },
		["<leader>la"] = { "<cmd> lua vim.lsp.buf.code_action()<cr>", "Show code actions" },
		["<leader>lp"] = { "<cmd> lua vim.diagnostic.goto_prev()<cr>", "Go to previous error" },
		["<leader>ln"] = { "<cmd> lua vim.diagnostic.goto_next()<cr>", "Go to next error" },
		["<leader>lh"] = { "<cmd> lua vim.lsp.buf.hover()<cr>", "Hover" },
		["<leader>ls"] = { "<cmd> lua vim.lsp.buf.signature_help()<cr>", "Hover" },
		["<leader>lr"] = { "<cmd> lua vim.lsp.buf.rename()<cr>", "Rename" },
		["<leader>lgd"] = { "<cmd> lua vim.lsp.buf.definition()<cr>", "Go to definition" },
		["<leader>lgD"] = { "<cmd> lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
		["<leader>lgi"] = { "<cmd> lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
		["<leader>lgt"] = { "<cmd> lua vim.lsp.buf.type_definition()<cr>", "Go to type definition" },
		["<leader>lgr"] = { "<cmd>Telescope lsp_references<cr>", "Show references" },
		["<leader>lf"] = { "<cmd>lua vim.lsp.diagnostic.open_float()<cr>", "Show diagnostics in floating window" },
	},
}

M.git = {
	n = {
		["<leader>gg"] = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Open Lazy Git" },
	},
}

M.toggleterm = {
	t = {
		["<A-i>"] = { "<cmd>ToggleTerm <CR>", "Toggle terminal" },
		["<A-h>"] = { "<cmd>1ToggleTerm size=100 direction=horizontal <cr>", "Toggle horizontal terminal" },
		["<A-v>"] = { "<cmd>3ToggleTerm size=100 direction=vertical<cr>", "Toggle vertical terminal" },
	},
	n = {
		["<A-i>"] = { "<cmd>ToggleTerm <CR>", "Toggle terminal" },
		["<A-h>"] = { "<cmd>1ToggleTerm<cr>", "Toggle horizontal terminal" },
		["<A-v>"] = { "<cmd>3ToggleTerm<cr>", "Toggle vertical terminal" },
	},
}

M.hop = {
	n = {
		["<leader>sf"] = {
			"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>",
			"HOP after cursor",
		},
		["<leader>sF"] = {
			"<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>",
			"HOP before cursor",
		},
	},
}

M.telescope = {
	n = {
		["<leader>pl"] = {
			"<cmd>Telescope project<cr>",
			"Show project list",
		},
	},
}

M.markdown = {
	n = {
		["<leader>mp"] = {
			"<cmd>MarkdownPreview<cr>",
			"Preview markdown",
		},
		["<leader>mt"] = {
			"<cmd>MarkdownToggle<cr>",
			"Toggle markdown preview",
		},
		["<leader>ms"] = {
			"<cmd>MarkdownStop<cr>",
			"Stop markdown preview",
		},
	},
}

M.bufferline = {
	n = {
		["<TAB>"] = {
			"<cmd>BufferLineCycleNext<CR>",
			"Go to next buffer",
		},
		["<S-TAB>"] = {
			"<cmd>BufferLineCyclePrev<CR>",
			"Go to previous buffer",
		},
		["<leader>bcl"] = {
			"<cmd>BufferLineCloseLeft<cr>",
			"Close buffers to the left",
		},
		["<leader>bcr"] = {
			"<cmd>BufferLineCloseRight<cr>",
			"Close buffers to the right",
		},
	},
}

-- TODO Take care of rest of this keybinds
M.disabled = {
	t = {
		-- toggle in terminal mode
		["<A-i>"] = "",
		["<A-h>"] = "",
		--
		-- ["<A-h>"] = {
		-- 	function()
		-- 		require("nvterm.terminal").toggle("horizontal")
		-- 	end,
		-- 	"toggle horizontal term",
		-- },
		--
		-- ["<A-v>"] = {
		-- 	function()
		-- 		require("nvterm.terminal").toggle("vertical")
		-- 	end,
		-- 	"toggle vertical term",
		-- },
	},

	n = {
		-- toggle in normal mode
		["<A-i>"] = "",
		["<A-h>"] = "",
		--
		-- ["<A-h>"] = {
		-- 	function()
		-- 		require("nvterm.terminal").toggle("horizontal")
		-- 	end,
		-- 	"toggle horizontal term",
		-- },
		--
		-- ["<A-v>"] = {
		-- 	function()
		-- 		require("nvterm.terminal").toggle("vertical")
		-- 	end,
		-- 	"toggle vertical term",
		-- },
		--
		-- -- new
		--
		-- ["<leader>h"] = {
		-- 	function()
		-- 		require("nvterm.terminal").new("horizontal")
		-- 	end,
		-- 	"new horizontal term",
		-- },
		--
		-- ["<leader>v"] = {
		-- 	function()
		-- 		require("nvterm.terminal").new("vertical")
		-- 	end,
		-- 	"new vertical term",
		-- },
	},
}

return M
