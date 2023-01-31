local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- core
	use("wbthomason/packer.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("MunifTanjim/nui.nvim")

	-- ui
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")

	-- buffers
	use({ "akinsho/bufferline.nvim", tag = "v2.*" })
	use("moll/vim-bbye")
	use("tiagovla/scope.nvim")

	-- performance
	use("lewis6991/impatient.nvim")

	-- theme
	use("projekt0n/github-nvim-theme")

	-- editing
	use("kylechui/nvim-surround")
	use("windwp/nvim-autopairs")
	use("numToStr/Comment.nvim")
	use({ "monaqa/dial.nvim", commit = "d2d7a57fb030c82b8b0d6712d9c35dfb49d9aa3c" })

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("ray-x/lsp_signature.nvim")

	-- lsp
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	use("jose-elias-alvarez/null-ls.nvim")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
	-- use("theHamsta/crazy-node-movement")
	use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" })
	use("danymat/neogen")

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-media-files.nvim")

	-- file tree
	use({ "nvim-neo-tree/neo-tree.nvim", branch = "v2.x" })

	-- symbols tree
	use("simrat39/symbols-outline.nvim")

	-- scratchpad
	use("hkupty/iron.nvim")

	-- git
	use("lewis6991/gitsigns.nvim")

	-- term
	use("akinsho/toggleterm.nvim")

	-- misc
	use("norcalli/nvim-colorizer.lua")
	use({ "echasnovski/mini.jump", branch = "stable" })
	use("ggandor/leap.nvim")
	use("folke/which-key.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
