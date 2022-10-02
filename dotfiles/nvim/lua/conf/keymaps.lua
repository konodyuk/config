local keymap = vim.api.nvim_set_keymap
local term_opts = { silent = true }

function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	keymap(mode, lhs, rhs, options)
end

--Remap space as leader key
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize with arrows
-- @TODO: Ctrl+Arrow conflicts with macos
map("n", "<A-Up>", ":resize +2<CR>")
map("n", "<A-Down>", ":resize -2<CR>")
map("n", "<A-Left>", ":vertical resize -2<CR>")
map("n", "<A-Right>", ":vertical resize +2<CR>")

-- Navigate buffer
map("n", "<S-l>", ":BufferLineCycleNext<CR>")
map("n", "<S-h>", ":BufferLineCyclePrev<CR>")

-- Insert --
-- Press jk fast to enter
map("i", "jk", "<ESC>")

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

map("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

map("n", "<leader>rt", "<cmd>IronRepl<cr>")
map("n", "<leader>rR", "<cmd>IronRestart<cr>")

map("n", "<S-Tab>", "<C-o>")

local status_ok, dial = pcall(require, "dial.map")
if status_ok then
	map("n", "<C-a>", dial.inc_normal())
	map("n", "<C-x>", dial.dec_normal())
	map("v", "<C-a>", dial.inc_visual())
	map("v", "<C-x>", dial.dec_visual())
	map("v", "g<C-a>", dial.inc_gvisual())
	map("v", "g<C-x>", dial.dec_gvisual())
end
