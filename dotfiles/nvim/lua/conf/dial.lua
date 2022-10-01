local augend = require("dial.augend")

require("dial.config").augends:register_group({
	-- default augends used when no group name is specified
	default = {
		augend.integer.alias.decimal_int,
		augend.integer.alias.hex,
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%Y-%m-%d"],
		-- augend.constant.alias.bool,
		augend.semver.alias.semver,
		augend.constant.new({
			elements = { "and", "or" },
			word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "&&", "||" },
			word = false,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "&", "|" },
			word = false,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "false", "true" },
			word = true,
			cyclic = true,
			preserve_case = true,
		}),
		augend.constant.new({
			elements = { "yes", "no" },
			word = true,
			cyclic = true,
			preserve_case = true,
		}),
		augend.constant.new({
			elements = { "==", "!=" },
			word = false,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { ">=", "<=" },
			word = false,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { ">", "<" },
			word = false,
			cyclic = true,
		}),
		augend.hexcolor.new({}),
	},
})
