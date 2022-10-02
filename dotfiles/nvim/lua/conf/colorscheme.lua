local status_ok, theme = pcall(require, "github-theme")
if not status_ok then
	return
end

theme.setup({
	theme_style = "dark_default",

	comment_style = "italic",
	keyword_style = "NONE",
	function_style = "NONE",
	variable_style = "NONE",
})
