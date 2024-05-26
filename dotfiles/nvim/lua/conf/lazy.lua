local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	-- colorscheme
	{
		"projekt0n/github-nvim-theme",
		priority = 1000,
		config = require("conf.colorscheme"),
		commit = "0e4887c614f6a982cdffb3651cd54543c7ef4e3e",
	},

	-- ui
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		config = require("conf.neotree"),
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"akinsho/bufferline.nvim",
		config = require("conf.bufferline"),
		dependencies = {
			"tiagovla/scope.nvim",
			"nvim-tree/nvim-web-devicons",
			"tiagovla/scope.nvim",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		config = require("conf.lualine"),
	},

	-- completion
	{
		"hrsh7th/nvim-cmp", -- The completion plugin,
		dependencies = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"ray-x/lsp_signature.nvim",
			{
				"L3MON4D3/LuaSnip", --snippet engine,
				config = require("conf.lsp.snippets"),
			},
			"rafamadriz/friendly-snippets", -- a bunch of snippets to use
		},
		config = require("conf.cmp"),
	},

	-- editing
	{
		"kylechui/nvim-surround",
		config = require("conf.surround"),
	},
	{
		"windwp/nvim-autopairs",
		config = require("conf.autopairs"),
	},
	{
		"monaqa/dial.nvim",
		config = require("conf.dial"),
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
		config = require("conf.lsp"),
		dependencies = {
			{
				"williamboman/mason.nvim",
				config = require("conf.lsp.mason"),
				dependencies = {
					"williamboman/mason-lspconfig.nvim",
				},
			},
			{
				"nvimtools/none-ls.nvim",
				config = require("conf.lsp.null-ls"),
			},
			{
				"tamago324/nlsp-settings.nvim",
			},
		},
	},

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-media-files.nvim",
		},
		config = require("conf.telescope"),
	},

	-- keybindings
	{
		"folke/which-key.nvim",
		config = require("conf.whichkey"),
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- commit = "e519877", -- FIXME: update when this issue is resolved: https://github.com/camdencheek/tree-sitter-dockerfile/issues/53
		event = { "BufReadPost", "BufNewFile" },
		config = require("conf.treesitter"),
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"RRethy/nvim-treesitter-endwise",
			-- "windwp/nvim-ts-autotag",
			{
				"danymat/neogen",
				config = require("conf.lsp.docstrings"),
			},
		},
	},

	-- symbol tree
	{

		"stevearc/aerial.nvim",
		config = require("conf.aerial"),
	},

	-- REPL
	{
		"hkupty/iron.nvim",
		config = require("conf.iron"),
	},

	-- git
	{
		"lewis6991/gitsigns.nvim",
		config = require("conf.gitsigns"),
	},

	-- terminal
	{
		"akinsho/toggleterm.nvim",
		config = require("conf.toggleterm"),
	},

	-- utils
	{
		"echasnovski/mini.nvim",
		config = require("conf.mini"),
	},

	-- misc
	{
		"norcalli/nvim-colorizer.lua",
		config = require("conf.colorizer"),
	},
	{
		"RRethy/vim-illuminate",
		config = require("conf.illuminate"),
	},
	{
		"ggandor/leap.nvim",
		config = require("conf.leap"),
	},
}

local options = {}

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	print("ERROR", lazy)
	return
end

lazy.setup(plugins, options)
