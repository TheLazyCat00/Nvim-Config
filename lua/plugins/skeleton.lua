local uv = vim.loop
local templatesDir = vim.fn.stdpath("config") .. "/skeleton"

return {
	"motosir/skel-nvim",
	enabled = false,
	event = "VeryLazy",
	opts = {
		templates_dir = templatesDir,
		mappings = {
			['*.py'] = ".py",
			['*.vue'] = ".vue",
			['CMakeLists.txt'] = "cmakelists.txt.skel",
			['CMakePresets.json'] = "cmakepresets.json",
		},
	},
	config = function (_, opts)
		require("skel-nvim").setup(opts)
		Print(require("skel-nvim").get_config())
	end
}
