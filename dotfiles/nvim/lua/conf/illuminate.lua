return function()
	require("illuminate").configure({
		-- providers: provider used to get references in the buffer, ordered by priority
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		-- delay: delay in milliseconds
		delay = 100,
		-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
		filetypes_denylist = {
			"neo-tree",
			"Outline",
			"toggleterm",
			"TelescopePrompt",
			"lazy",
		},
		min_count_to_highlight = 2,
	})

	vim.cmd([[ hi link IlluminatedWordText LspReferenceText ]])
	vim.cmd([[ hi link IlluminatedWordRead IlluminatedWordText ]])
	vim.cmd([[ hi link IlluminatedWordWrite IlluminatedWordText ]])
end
