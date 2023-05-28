return {
  "neovim/nvim-lspconfig",
  dependencies = { "mason-lspconfig.nvim", "which-key.nvim", "cmp-nvim-lsp" },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    vim.diagnostic.config({
      virtual_text = false,
    })

    -- Show line diagnostics automatically in hover window
    -- vim.o.updatetime = 50
    -- vim.cmd([[autocmd CursorHold,CursorHoldI * :Lspsaga show_cursor_diagnostics ++unfocus]])

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
      on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
        _LSP_ATTACH(client, bufnr)
      end,
    })
  end,
}
