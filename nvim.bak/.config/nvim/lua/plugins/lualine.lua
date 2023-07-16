return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.sections.lualine_x = nil
    return {
      options =
      {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
    }
  end
}
