local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "all", -- one of "all" or a list of languages
	sync_install = false,
	ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = { "python", "css" },
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		config = {
			lua = { __default = "-- %s", __multiline = "-- %s" },
		},
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer", -- for "argument"
				["ia"] = "@parameter.inner",
				-- ["aC"] = "@comment.outer",
				-- ["ai"] = "@block.outer", -- for "indent"
				-- ["ii"] = "@block.inner",
			},
			-- You can choose the select mode (default is charwise 'v')
			selection_modes = {
				-- ["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@function.inner"] = "V", -- linewise
				["@class.outer"] = "V", -- linewise
				["@class.inner"] = "V", -- linewise
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_end = {
				["]a"] = "@parameter.outer",
			},
			goto_previous_start = {
				["[a"] = "@parameter.outer",
				["[c"] = "@class.outer",
				["[f"] = "@function.outer",
				-- ["[C"] = "@comment.outer",
			},
			goto_next_start = {
				["]c"] = "@class.outer",
				["]f"] = "@function.outer",
				-- ["]C"] = "@comment.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["][a"] = "@parameter.inner",
				["][f"] = "@function.outer",
				["][c"] = "@class.outer",
			},
			swap_previous = {
				["[]a"] = "@parameter.inner",
				["[]f"] = "@function.outer",
				["[]c"] = "@class.outer",
			},
		},
	},
})

local status_ok, presets = pcall(require, "which-key.plugins.presets")
if status_ok then
	presets.objects["af"] = [[a function]]
	presets.objects["if"] = [[inside function]]
	presets.objects["ac"] = [[a class]]
	presets.objects["ic"] = [[inside class]]
	presets.objects["aa"] = [[a parameter]]
	presets.objects["ia"] = [[inside parameter]]
	presets.objects["gc"] = [[a comment block]]

	presets.motions["]a"] = [[next parameter (end of)]]
	presets.motions["]c"] = [[next class]]
	presets.motions["]f"] = [[next function]]
	-- presets.motions["]C"] = [[next comment]]

	presets.motions["[a"] = [[previous parameter]]
	presets.motions["[c"] = [[previous class]]
	presets.motions["[f"] = [[previous function]]
	-- presets.motions["[C"] = [[previous comment]]
end
