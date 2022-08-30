local which_key_config = require("user.plugins.which_key")
local autopairs_config = require("user.plugins.autopairs")
local telescope_config = require("user.plugins.telescope")
local telescope_media_config = require("user.plugins.telescope_media")
local telescope_projects_config = require("user.plugins.telescope_projects")
local treesitter_config = require("user.plugins.treesitter")
local nvim_tree_config = require("user.plugins.nvim_tree")
local coq_nvim_config = require("user.plugins.coq_nvim")
local lsp_config = require("user.plugins.lsp.lsp_config")
local mason = require("user.plugins.lsp.mason")
local mason_lspconfig = require("user.plugins.lsp.mason_lspconfig")
local null_ls_config = require("user.plugins.lsp.null_ls")
local bufferline_config = require("user.plugins.bufferline")
local rust_tools_config = require("user.plugins.lsp.rust_tools")
local hop_config = require("user.plugins.hop")
local gitsigns_config = require("user.plugins.gitsigns")
local alpha_config = require("user.plugins.alpha")
local comment_config = require("user.plugins.comment")
local lualine_config = require("user.plugins.lualine")

local plugins = {
	["folke/tokyonight.nvim"] = {},
	["nvim-lua/popup.nvim"] = {},
	["nvim-lua/plenary.nvim"] = {},
	["folke/which-key.nvim"] = which_key_config,
	["windwp/nvim-autopairs"] = autopairs_config,
	["nvim-telescope/telescope-media-files.nvim"] = telescope_media_config,
	["nvim-telescope/telescope-project.nvim"] = telescope_projects_config,
	["nvim-telescope/telescope.nvim"] = telescope_config,
	["nvim-treesitter/nvim-treesitter"] = treesitter_config,
	["p00f/nvim-ts-rainbow"] = {},
	["nvim-treesitter/playground"] = {},
	["kyazdani42/nvim-tree.lua"] = nvim_tree_config,
	["ms-jpq/coq.artifacts"] = { branch = "artifacts" },
	["ms-jpq/coq_nvim"] = coq_nvim_config,
	["williamboman/mason.nvim"] = mason,
	["williamboman/mason-lspconfig.nvim"] = mason_lspconfig,
	["neovim/nvim-lspconfig"] = lsp_config,
	["jose-elias-alvarez/null-ls.nvim"] = null_ls_config,
	["akinsho/bufferline.nvim"] = bufferline_config,
	["simrat39/rust-tools.nvim"] = rust_tools_config,
	["phaazon/hop.nvim"] = hop_config,
	["lewis6991/gitsigns.nvim"] = gitsigns_config,
	["goolord/alpha-nvim"] = alpha_config,
	["numToStr/Comment.nvim"] = comment_config,
	["nvim-lualine/lualine.nvim"] = lualine_config,
}

return plugins
