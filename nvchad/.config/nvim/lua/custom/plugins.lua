local plugins = {
	{
		"simrat39/rust-tools.nvim",
		config = function()
			require("custom.configs.rust-tools")
		end,
		ft = { "rust" },
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("custom.configs.null-ls")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
			require("core.utils").load_mappings("lsp_custom")
		end,
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua-language-server",
					"prettier",
					"stylua",
					"slint-lsp",
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		opts = {
			sources = {
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "crates" },
				-- { name = "buffer" },
			},
			mapping = {
				["<C-j>"] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
				["<C-k>"] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
				["<CR>"] = require("cmp").mapping.confirm({
					behavior = require("cmp").ConfirmBehavior.Insert,
					select = true,
				}),
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = require("telescope.actions").move_selection_next,
						["<C-k>"] = require("telescope.actions").move_selection_previous,
					},
					n = {
						["j"] = require("telescope.actions").move_selection_next,
						["k"] = require("telescope.actions").move_selection_previous,
					},
				},
			},
		},
	},
	{
		"ur4ltz/surround.nvim",
		config = function()
			require("surround").setup({
				mapping_style = "surround",
			})
		end,
		lazy = false,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("treesitter-context").setup()
		end,
		event = "LspAttach",
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = false, -- TODO: Change this to keybind
	},
	{
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup({
				keys = "qwertyuiopasdfgh",
			})
		end,
		lazy = false,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup()

			require("core.utils").load_mappings("trouble")
		end,
		keys = { "<leader>q", "<leader>Q" },
	},
	{
		"gpanders/nvim-parinfer",
		ft = { "yuck" },
	},
	{
		"elkowar/yuck.vim",
		ft = { "yuck" },
	},
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
			require("core.utils").load_mappings("outline")
		end,
		event = "LspAttach",
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		config = function()
			require("fidget").setup()
		end,
	},
	{
		"anuvyklack/hydra.nvim",
		lazy = false,
		config = function()
			local Hydra = require("hydra")

			Hydra({
				name = "Pane moving",
				mode = "n",
				body = "<leader>m",
				heads = {
					{ "h", "<C-W>h" },
					{ "l", "<C-W>l" },
					{ "j", "<C-W>j" },
					{ "k", "<C-W>k" },
				},
			})
		end,
	},
	{
		"nvim-picker",
		url = "https://gitlab.com/yorickpeterse/nvim-window",
		opt = {},
	},

	-- {
	-- 	"lvimuser/lsp-inlayhints.nvim",
	-- 	branch = "anticonceal",
	-- 	init = function()
	-- 		vim.api.nvim_create_autocmd("LspAttach", {
	-- 			group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
	-- 			callback = function(args)
	-- 				if not (args.data and args.data.client_id) then
	-- 					return
	-- 				end
	-- 				local client = vim.lsp.get_client_by_id(args.data.client_id)
	-- 				require("lsp-inlayhints").on_attach(client, args.buf)
	-- 			end,
	-- 		})
	-- 	end,
	-- 	config = function()
	-- 		require("lsp-inlayhints").setup({})
	-- 		vim.api.nvim_set_hl(0, "LspInlayHint", { bg = nil, fg = "#545c62" })
	-- 	end,
	-- 	event = "LspAttach",
	-- },
	-- {
	-- 	"nvimdev/lspsaga.nvim",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	event = "LspAttach",
	-- 	config = function()
	-- 		require("lspsaga").setup({
	-- 			symbol_in_winbar = {
	-- 				enable = false,
	-- 			},
	-- 			lightbulb = {
	-- 				enable = false,
	-- 			},
	-- 		})
	--
	-- 		require("core.utils").load_mappings("lspsaga")
	-- 	end,
	-- },
}

return plugins
