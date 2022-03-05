local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

------------------------------
-- 'Normal' Keybinds
------------------------------
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Moving between windows
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

------------------------------
-- Which key keybindings
------------------------------
wk.register({
	f = {
		name = "File",
		f = {
			"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
			"Search for file",
		},
		s = {
			":w<cr>",
			"Save buffer",
		},
		n = {
			":ene <BAR> startinsert <CR>",
			"Create new file in current directory",
		},
	},
	w = {
		name = "Window",
		v = {
			"<cmd>vsplit<cr>",
			"Create vertical split",
		},
		q = {
			"<cmd>q<cr>",
			"Close window",
		},
	},
	t = {
		name = "Toggle",
		e = {
			":NvimTreeToggle<cr>",
			"Toggle file explorer",
		},
	},
	v = {
		name = "vim",
		s = {
			":source<cr>",
			"Source file",
		},
	},
	l = {
		name = "Lsp",
		f = {
			":lua vim.lsp.buf.formatting_sync()<cr>",
			"Format buffer",
		},
		a = {
			":lua vim.lsp.buf.code_action()<cr>",
			"Show code actions",
		},
		k = {
			":lua vim.lsp.buf.hover()<cr>",
			"Show on hover",
		},
    r = {
      ":lua vim.lsp.buf.rename()<cr>",
      "Rename variable"
    },
		d = {
			name = "Diagnostics",
			o = {
				":lua vim.diagnostic.open_float({border = 'rounded'})<cr>",
				"Open Diagnostics",
			},
			p = {
				": lua vim.diagnostic.goto_prev({ border = 'rounded'})<CR>",
				"Previous diagnostic",
			},
			n = {
				":lua vim.diagnostic.goto_next({border = 'rounded'})<cr>",
				"Next Diagnostics",
			},
			l = {
				":lua vim.diagnostic.setloclist()<cr>",
				"Show list of Diagnostics",
			},
		},
		g = {
			name = "Go to",
			D = {
				":lua vim.lsp.buf.declaration()<cr>",
				"Go to declaration",
			},
			d = {
				":lua vim.lsp.buf.definition()<cr>",
				"Go to definition",
			},
			i = {
				":lua vim.lsp.buf.implementation()<cr>",
				"Go to implementation",
			},
			r = {
				":Telescope lsp_references<cr>",
				"Go to references",
			},
		},
	},
}, { prefix = "<leader>" })
