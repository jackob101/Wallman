return {
	config = function()
		local wk = require("which-key")
		wk.setup()

		wk.register({
			["<C-n>"] = { "<cmd>NvimTreeToggle<CR>", "Toggle file explorer" },
			["<leader>w"] = { "<cmd>w<cr>", "Save buffer" },
			["<leader>q"] = { "<cmd>q<cr>", "Quit buffer" },
			-- 			["<TAB>"] = {
			-- 				"<cmd>BufferLineCycleNext<CR>",
			-- 			"Go to next buffer",
			-- },
			-- 	["<S-TAB>"] = {
			-- "<cmd>BufferLineCyclePrev<CR>",
			-- "Go to previous buffer",
			-- },
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
			["<leader>b"] = {
				["l"] = {
					"<cmd>BufferLineCloseLeft<cr>",
					"Close buffers to the left",
				},
				["<leader>bcr"] = {
					"<cmd>BufferLineCloseRight<cr>",
					"Close buffers to the right",
				},
			},
		})
	end,
}
