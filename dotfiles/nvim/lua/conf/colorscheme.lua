local status_ok, theme = pcall(require, "github-theme")
if not status_ok then
	return
end

theme.setup({
	theme_style = "dark_default",

	options = { styles = {
		comments = "italic",
		keywords = "NONE",
		functions = "NONE",
		variables = "NONE",
	} },
})
