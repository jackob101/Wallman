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
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		opts = {
			mapping = {
				["<C-j>"] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
				["<C-k>"] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
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
			require("surround").setup({ mapping_style = "surround" })
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
}

return plugins
