return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        virtual_lines = true,
      },
    },
  },

  {
    "ErichDonGubler/lsp_lines.nvim",
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    opts = {},
    keys = {
      { "<leader>hl", "<cmd>lua require('lsp_lines').toggle()<cr>", desc = "Toggle lsp_lines" },
    },
  },
}
