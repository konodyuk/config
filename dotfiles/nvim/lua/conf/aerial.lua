return function()
	require("aerial").setup({
		layout = {
			max_width = { 40, 0.2 },
			width = nil,
			min_width = 20,
		},
		manage_folds = true,
		link_folds_to_tree = false,
		link_tree_to_folds = true,
	})
end
