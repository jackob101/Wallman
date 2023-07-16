return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  opts = function()
    local nls = require("null-ls")
    return {
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        nls.builtins.formatting.rustfmt.with({
          extra_args = { "--edition=2021" },
        }),
        nls.builtins.formatting.black
        -- nls.builtins.diagnostics.flake8,
      },
    }
  end,
}
