return function()
	local status_ok, surround = pcall(require, "nvim-surround")
	if not status_ok then
		return
	end

	surround.setup({
		keymaps = {
			normal = "ys",
			delete = "ds",
			change = "cs",

			-- remapped from `S` to not conflict with leap backward search in visual
			-- and for better consistency
			-- TODO: visual yanking is now slower
			visual = "ys",

			-- disabled because Vys works just as well
			visual_line = false, -- "yS",

			-- disabled because autopair already does it in insert
			insert = false,
			insert_line = false,

			-- disabled because it is not frequently used and doesn't need a dedicated keymap
			-- normal_cur: yss" -> ysil" == vilys"
			-- normal_cur_line: ySS" -> Vys"
			-- normal_line: yS<motion>" -> V<motion>ys"
			normal_cur = false,
			normal_line = false,
			normal_cur_line = false,
		},
	})
end
