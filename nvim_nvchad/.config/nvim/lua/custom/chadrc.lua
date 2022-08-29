-- Just an example, supposed to be placed in /lua/custom/

--
vim.g.coq_settings = {
	auto_start = true,
}

local M = {}
-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

local rust_tools_config = require("custom.plugins.rust-tools")
local which_key_config = require("custom.plugins.which-key")
local toggleterm_config = require("custom.plugins.toggleterm")
local ui_config = require("custom.plugins.ui")
local hop_config = require("custom.plugins.hop")
local telescope_project_config = require("custom.plugins.telescope_project")
local alpha_config = require("custom.plugins.alpha")
local markdown_preview_config = require("custom.plugins.markdown_preview")
local bufferline_config = require("custom.plugins.bufferline")
local vim_illuminate_config = require("custom.plugins.vim_illuminate")
local nvim_tree_config = require("custom.plugins.nvim_tree")
local coq_nvim_config = require("custom.plugins.coq_nvim")
local autopairs_config = require("custom.plugins.nvim_autopairs")
local null_ls_config = {
	after = "nvim-lspconfig",
	config = function()
		require("custom.plugins.null-ls")
	end,
}

M.ui = {
	theme = "tokyonight",
	hl_override = {
		CursorLine = {
			bg = "#30313B",
		},
		NvimTreeWinSeparator = {
			fg = "#32333e",
			bg = "#1a1b26",
		},
	},
	hl_add = {
		BufferLineOffsetSeparator = {
			fg = "#32333e",
			bg = "#1a1b26",
		},
	},
}

M.plugins = {

	override = {
		["nvim-treesitter/nvim-treesitter"] = {
			ensure_installed = {
				"rust",
				"lua",
			},
		},
		["NvChad/ui"] = ui_config,
		["goolord/alpha-nvim"] = alpha_config,
		["kyazdani42/nvim-tree.lua"] = nvim_tree_config,
	},

	user = {
		["windwp/nvim-autopairs"] = autopairs_config,
		["goolord/alpha-nvim"] = { disable = false },
		["folke/which-key.nvim"] = which_key_config,
		["jose-elias-alvarez/null-ls.nvim"] = null_ls_config,
		["neovim/nvim-lspconfig"] = {},
		["simrat39/rust-tools.nvim"] = rust_tools_config,
		["akinsho/toggleterm.nvim"] = toggleterm_config,
		["phaazon/hop.nvim"] = hop_config,
		["nvim-telescope/telescope-project.nvim"] = telescope_project_config,
		["iamcco/markdown-preview.nvim"] = markdown_preview_config,
		["akinsho/bufferline.nvim"] = bufferline_config,
		["RRethy/vim-illuminate"] = vim_illuminate_config,
		["ms-jpq/coq.artifacts"] = { branch = "artifacts" },
		["ms-jpq/coq_nvim"] = coq_nvim_config,
	},
	remove = {
		"hrsh7th/nvim-cmp",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
}

M.mappings = require("custom.mappings")

return M
