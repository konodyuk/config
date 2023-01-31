local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = false,
	--[[ shading_factor = "3", ]]
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	-- vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	-- vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)

	-- ref: https://github.com/equalsraf/neovim-qt/issues/259#issuecomment-475829115
	vim.api.nvim_buf_set_keymap(0, "t", "<S-Space>", [[<Space>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<S-Backspace>", [[<Backspace>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-Backspace>", [[<Backspace>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal

--[[ local term = Terminal:new({ hidden = true }) ]]
--[[]]
--[[ function _TERM_TOGGLE() ]]
--[[ 	term:toggle() ]]
--[[ end ]]

local gitui = Terminal:new({
	cmd = "gitui",
	hidden = true,
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", [[<c-\>]], "<cmd>close<CR>", { noremap = true, silent = true })
		-- vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
})

function _GITUI_TOGGLE()
	gitui:toggle()
end

-- local node = Terminal:new({ cmd = "node", hidden = true })
--
-- function _NODE_TOGGLE()
-- 	node:toggle()
-- end
--
-- local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })
--
-- function _NCDU_TOGGLE()
-- 	ncdu:toggle()
-- end
--
-- local htop = Terminal:new({ cmd = "htop", hidden = true })
--
-- function _HTOP_TOGGLE()
-- 	htop:toggle()
-- end
--
-- local python = Terminal:new({ cmd = "python", hidden = true })
--
-- function _PYTHON_TOGGLE()
-- 	python:toggle()
-- end
