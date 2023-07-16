return {
  'jose-elias-alvarez/null-ls.nvim',
  config = function()
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    local null_ls = require 'null-ls'
    local b = null_ls.builtins

    null_ls.setup {
      debug = true,
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr }
            end,
          })
        end
      end,
      sources = {
        -- Lua
        b.formatting.stylua,
        b.formatting.prettier,

        -- Shell
        -- b.formatting.shfmt,
        -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

        -- Rust
        b.formatting.rustfmt,

        -- Json
        b.formatting.jq,
      },
    }
  end,
}
