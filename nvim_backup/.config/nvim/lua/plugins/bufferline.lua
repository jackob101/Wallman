return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("bufferline").setup({
      options = {
        tab_size = 25,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "NvimTree",
            text = "Directory",
            highlight = "Directory",
            text_align = "center",
            separator = true,
          },
          {
            filetype = "lspsagaoutline",
            text = "Structure",
            highlight = "Directory",
            text_align = "center",
            separator = true,
          },
        },
      },
    })
  end,
}
