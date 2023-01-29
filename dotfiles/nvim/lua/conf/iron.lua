local status_ok, iron = pcall(require, "iron.core")
if not status_ok then
	return
end

iron.setup({
	config = {
		highlight_last = "IronLastSent",
		-- If iron should expose `<plug>(...)` mappings for the plugins
		-- should_map_plug = false,
		-- Whether a repl should be discarded or not
		scratch_repl = true,
		-- Your repl definitions come here
		repl_definition = {
			sh = {
				command = { "zsh" },
			},
			python = require("iron.fts.python").ipython,
			applescript = {
				command = { "osascript", "-i" },
			},
			sql = {
				command = { "sqlite3" },
			},
		},
		-- how the REPL window will be opened, the default is opening
		-- a float window of height 40 at the bottom.
		repl_open_cmd = require("iron.view").right(function()
			return 80
		end),
		scope = require("iron.scope").singleton,
	},
	-- Iron doesn't set keymaps by default anymore. Set them here
	-- or use `should_map_plug = true` and map from you vim files
	keymaps = {
		send_motion = "<leader>r",
		visual_send = "<leader>r",
		-- send_file = "zf",
		-- send_line = "zl",
		-- send_mark = "zm",
		-- mark_motion = "zc",
		-- mark_visual = "<leader>mc",
		-- remove_mark = "<leader>md",
		-- cr = "<leader>s<cr>",
		interrupt = "<leader>rq",
		-- exit = "zq",
		-- clear = "<leader>cl",
	},
	-- If the highlight is on, you can change how it looks
	-- For the available options, check nvim_set_hl
	highlight = {
		-- italic = true,
		-- link = "Visual",
		bg = "#341a00",
		-- underline = true,
	},
})
