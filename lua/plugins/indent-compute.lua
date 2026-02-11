return {
	"nvim-mini/mini.indentscope",
	version = false, -- wait till new 0.7.0 release to put it back on semver
	event = "LazyFile",
	opts = {
		options = {
			try_as_border = true,
		},
		draw = {
			predicate = function (scope)
				return false
			end,
			priority = 0
		}
	},
}
