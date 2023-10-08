return {
  {
    'dgagn/diagflow.nvim',
    opts = {},
  },
  -- {
  --   'nvimdev/lspsaga.nvim',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter', -- optional
  --     'nvim-tree/nvim-web-devicons', -- optional
  --   },
  --   after = 'nvim-lspconfig',
  --   opts = {
  --     ui = {
  --       symbol_in_winbar = {
  --         enable = false,
  --       },
  --       breadcrumb = {
  --         enable = false,
  --       },
  --     },
  --     lightbulb = {
  --       enable = false,
  --     },
  --   },
  -- },
  {
    'ErichDonGubler/lsp_lines.nvim',
    url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    opts = {},
    keys = {
      { '<leader>tl', "<cmd>lua require('lsp_lines').toggle()<cr>", desc = 'Toggle lsp_lines' },
    },
  },
}
