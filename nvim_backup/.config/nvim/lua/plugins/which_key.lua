return {
  "folke/which-key.nvim",
  config = function()
    local wk = require("which-key")
    wk.setup()

    wk.register({
      ["<C-n>"] = { "<cmd>NvimTreeOpen<CR>", "Toggle file explorer" },
      ["<C-w>"] = { "<cmd>Bdelete<cr>", "Close current buffer" },
      ["<C-s>"] = { "<cmd>w<cr>", "Save buffer" },
      ["<A-i>"] = { "<cmd>ToggleTerm <CR>", "Toggle terminal" },
      ["<A-h>"] = { "<cmd>lua _HORIZONTAL_TERMINAL_TOGGLE()<cr>", "Toggle horizontal terminal" },
      ["<A-v>"] = { "<cmd>3ToggleTerm size=100 direction=vertical<cr>", "Toggle vertical terminal" },
      ["<leader>w"] = { "<cmd>w<cr>", "Save buffer" },
      ["<leader>q"] = { "<cmd>q<cr>", "Quit buffer" },
      ["<leader>f"] = {
        name = "File",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
      },
      ["<leader>h"] = {
        "<cmd>lua require'hop'.hint_char2({ current_line_only = false })<cr>",
        "HOP",
      },
      ["<leader>l"] = {
        name = "LSP",
        -- p = { "<cmd> lua vim.diagnostic.goto_prev()<cr>", "Go to previous error" },
        -- n = { "<cmd> lua vim.diagnostic.goto_next()<cr>", "Go to next error" },
        f = { "<cmd>lua vim.lsp.diagnostic.open_float()<cr>", "Show diagnostics in floating window" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature" },
      },
      ["<leader>s"] = {
        name = "search",
        l = { "<cmd> Telescope live_grep<cr>", "Telescope live grep" },
      },
      ["<leader>b"] = {
        name = "Buffers",
        cl = {
          "<cmd>BufferLineCloseLeft<cr>",
          "Close buffers to the left",
        },
        cr = {
          "<cmd>BufferLineCloseRight<cr>",
          "Close buffers to the right",
        },
        x = {
          "<cmd>Bdelete<cr>",
          "Close current buffer",
        },
      },

      ["<leader>g"] = {
        name = "GIT",
        g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Open Lazy Git" },
      },

      ["<leader>p"] = {
        name = "Project",
        l = { "<cmd>Telescope project<cr>", "Show project list" },
      },
    })

    wk.register({
      ["<A-i>"] = { "<cmd>ToggleTerm <CR>", "Toggle terminal" },
      ["<A-h>"] = { "<cmd>lua _HORIZONTAL_TERMINAL_TOGGLE()<cr>", "Toggle horizontal terminal" },
      ["<A-v>"] = { "<cmd>3ToggleTerm<cr>", "Toggle vertical terminal" },
    }, { mode = "t" })

    function _LSP_ATTACH(_, bufnr)
      local bufopt = { noremap = true, silent = true, buffer = bufnr }

      wk.register({
        ["<C-p>"] = { " <cmd>lua vim.lsp.buf.signature_help(bufopt)<cr>", "Signature help" },
        ["<leader>l"] = {
          name = "LSP",
          g = {
            name = "Goto",
            D = { "<cmd>lua vim.lsp.buf.declaration(bufopt)<cr>", "Go to declaration" },
            d = { " <cmd>lua vim.lsp.buf.definition(bufopt)<cr>", "Go to definition" },
            i = { " <cmd>lua vim.lsp.buf.implementation(bufopt)<cr>", "Go to implementation" },
            r = { " <cmd>Telescope lsp_references<cr>", "Go to references" },
          },
          h = { " <cmd>Lspsaga hover_doc<cr>", "Show hover" },
          t = { "<cmd>lua  vim.lsp.buf.type_definition(bufopt)<cr>", "Type definition" },
          r = { " <cmd>lua vim.lsp.buf.rename(bufopt)<cr>", "Rename" },
          a = { " <cmd>Lspsaga code_action<cr>", "Code actions" },
          f = { " <cmd>lua vim.lsp.buf.format(bufopt)<cr>", "Format" },
          o = { "<cmd>Lspsaga outline<cr>", "Outline" },
          p = {
            name = "Peek",
            d = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" },
            t = { "<cmd>Lspsaga peek_type_definition<cr>", "Peek type definition" },
          },
          d = {
            name = "Diagnostics",
            c = { "<cmd>Lspsaga show_cursor_diagnostics ++unfocus<cr>", "Show cursor diagnostics" },
            w = { "<cmd>Trouble<cr>", "Show diagnostics for all buffers" },
            b = { "<cmd>Trouble document_diagnostics<cr>", "Show diagnostics for current buffer" },
          },

          -- LSPSAGA
        },

        ["<F2>"] = {
          "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
          "Go to next diagnostic",
        },
      }, bufopt)
    end
  end,
}
