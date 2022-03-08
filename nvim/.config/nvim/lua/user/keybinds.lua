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
	b = {
		name = "Buffer",
		c = {
			":Bdelete!<cr>",
			"Close buffer",
		},
		f = {
			":Telescope current_buffer_fuzzy_find<cr>",
			"Search in buffer",
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
	h = {
		name = "Help",
		t = {
			":Telescope help_tags<cr>",
			"Help tags",
		},
	},
	t = {
		name = "Toggle",
		e = {
			":NvimTreeToggle<cr>",
			"Toggle file explorer",
		},
    g = {
      ":Neogit<cr>",
      "Toggle neogit"
    }
	},
	v = {
		name = "vim",
		s = {
			":source<cr>",
			"Source file",
		},
	},

}, { prefix = "<leader>" })
