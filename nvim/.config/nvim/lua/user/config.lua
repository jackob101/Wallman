local which_key_config = require("user.plugins.which_key")
local autopairs_config = require("user.plugins.autopairs")
local telescope_config = require("user.plugins.telescope")
local telescope_media_config = require("user.plugins.telescope_media")
local telescope_projects_config = require("user.plugins.telescope_projects")
local treesitter_config = require("user.plugins.treesitter")
local nvim_tree_config = require("user.plugins.nvim_tree")
local coq_nvim_config = require("user.plugins.coq_nvim")

local plugins = {
	"folke/tokyonight.nvim",
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	which_key_config,
	autopairs_config,
	telescope_media_config,
	telescope_projects_config,
	telescope_config,
	treesitter_config,
	"p00f/nvim-ts-rainbow",
	"nvim-treesitter/playground",
	nvim_tree_config,
	{ "ms-jpq/coq.artifacts", branch = "artifacts" },
	coq_nvim_config,
}

return plugins
