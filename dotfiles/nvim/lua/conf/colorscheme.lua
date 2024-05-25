return function()
	local status_ok, theme = pcall(require, "github-theme")
	if not status_ok then
		return
	end

	theme.setup({
		options = {
			styles = {
				comments = "italic",
				keywords = "NONE",
				functions = "NONE",
				variables = "NONE",
			},
		},
		-- in case of further updates
		-- palettes = {
		-- 	github_dark_default = {
		-- 		bg3 = "#161b22",
		-- 	},
		-- },
		-- specs = {
		-- 	github_dark_default = {
		-- 		-- FIXME: currently each overridden layer needs to be reexported
		-- 		-- ref: https://github.com/projekt0n/github-nvim-theme/issues/303
		-- 		bg3 = "bg3",
		-- 	},
		-- },
		-- groups = {
		-- 	github_dark_default = {
		-- 		CursorLine = {
		-- 			bg = "#161b22",
		-- 		},
		-- 	},
		-- },
	})

	vim.cmd([[colorscheme github_dark_default]])
end
