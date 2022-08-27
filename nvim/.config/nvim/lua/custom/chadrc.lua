-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

local rust_tools_config = require "custom.plugins.rust-tools"
local which_key_config = require "custom.plugins.which-key"
local toggleterm_config = require "custom.plugins.toggleterm"
local ui_config = require "custom.plugins.ui"

M.ui = {
  theme = "tokyonight",
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
  },

  user = {
    ["goolord/alpha-nvim"] = { disable = false },
    ["folke/which-key.nvim"] = which_key_config,
    ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
        require "custom.plugins.null-ls"
      end,
    },
    ["neovim/nvim-lspconfig"] = {},
    ["simrat39/rust-tools.nvim"] = rust_tools_config,
    ["akinsho/toggleterm.nvim"] = toggleterm_config,
  },
}

M.mappings = require "custom.mappings"

return M
