return {
  "simrat39/rust-tools.nvim",
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    require("rust-tools").setup({
      tools = { -- rust-tools options
        hover_with_actions = true,
        inlay_hints = {
          show_parameter_hints = false,
          parameter_hints_prefix = "",
          other_hints_prefix = "",
          auto = true,
        },
      },

      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
      server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          _LSP_ATTACH(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
        end,
        settings = {
          -- to enable rust-analyzer settings visit:
          -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
          ["rust-analyzer"] = {
            -- enable clippy on save
            checkOnSave = {
              command = "clippy",
            },
            completion = {
              postfix = {
                enable = false,
              },
            },
          },
        },
      },
    })
  end,
  ft = { "rust", "rs" },
}
