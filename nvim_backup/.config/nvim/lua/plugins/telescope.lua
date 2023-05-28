return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local status_ok, telescope = pcall(require, "telescope")
		if not status_ok then
			return
		end

		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {

				prompt_prefix = "  ",
				selection_caret = "  ",
				path_display = { "smart" },

				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,

						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,

						["<C-c>"] = actions.close,

						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,

						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,

						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,

						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,

						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-l>"] = actions.complete_tag,
						["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
					},

					n = {
						["<esc>"] = actions.close,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,

						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
						["H"] = actions.move_to_top,
						["M"] = actions.move_to_middle,
						["L"] = actions.move_to_bottom,

						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["gg"] = actions.move_to_top,
						["G"] = actions.move_to_bottom,

						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,

						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,

						["?"] = actions.which_key,
					},
				},
			},
			pickers = {
				-- Default configuration for builtin pickers goes here:
				-- picker_name = {
				--   picker_config_key = value,
				--   ...
				-- }
				-- Now the picker_config_key will be applied every time you call this
				-- builtin picker
			},
			extensions = {
				media_files = {
					-- filetypes whitelist
					-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
					filetypes = { "png", "webp", "jpg", "jpeg" },
					find_cmd = "rg", -- find command (defaults to `fd`)
				},
				-- Your extension configuration goes here:
				-- extension_name = {
				--   extension_config_key = value,
				-- }
				-- please take a look at the readme of the extension you want to configure
			},
		})

		vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

		local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)

		local preview_bg = "#333352"
		local result_bg = "#1e2030"
		local prompt_bg = "#2f334d"
		local red1 = "#c3e88d"
		local green1 = "#ff966c"
		local blue1 = "#0985de"

		----------------------------------------------------------------------
		--                              Prompt                              --
		----------------------------------------------------------------------
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", {
			fg = prompt_bg,
			bg = prompt_bg,
		})

		vim.api.nvim_set_hl(0, "TelescopePromptNormal", {
			fg = normal_hl.foreground,
			bg = prompt_bg,
		})

		vim.api.nvim_set_hl(0, "TelescopePromptTitle", {
			fg = normal_hl.background,
			bg = red1,
		})

		vim.api.nvim_set_hl(0, "TelescopePromptCounter", {
			fg = red1,
			bg = prompt_bg,
		})

		vim.api.nvim_set_hl(0, "TelescopePromptPrefix", {
			fg = red1,
			bg = prompt_bg,
		})

		----------------------------------------------------------------------
		--                              Result                              --
		----------------------------------------------------------------------
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", {
			fg = result_bg,
			bg = result_bg,
		})

		vim.api.nvim_set_hl(0, "TelescopeResultsNormal", {
			fg = normal_hl.foreground,
			bg = result_bg,
		})

		vim.api.nvim_set_hl(0, "TelescopeResultsTitle", {
			fg = result_bg,
			bg = blue1,
		})

		vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", {
			fg = blue1,
			bg = vim.api.nvim_get_hl_by_name("TelescopeSelection", true).background,
		})

		----------------------------------------------------------------------
		--                             Preview                              --
		----------------------------------------------------------------------

		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", {
			fg = preview_bg,
			bg = preview_bg,
		})

		vim.api.nvim_set_hl(0, "TelescopePreviewNormal", {
			fg = normal_hl.foreground,
			bg = preview_bg,
		})

		vim.api.nvim_set_hl(0, "TelescopePreviewTitle", {
			fg = normal_hl.background,
			bg = green1,
		})
	end,
}
