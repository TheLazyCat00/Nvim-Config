return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Use latest code changes
	opts = {
		provider = "copilot2",
		auto_suggestions_provider = "copilot4",

		behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = true,
			support_paste_from_clipboard = true,
			minimize_diff = true,
			enable_token_counting = false,
		},
		file_selector = {
			provider = "native",
			provider_opts = {},
		},
		web_search_engine = {
			provider = "google",
		},
		disabled_tools = { "python" },

		copilot = {
			endpoint = "https://api.githubcopilot.com",
			proxy = nil, -- [protocol://]host[:port] Use this proxy
			allow_insecure = false, -- Allow insecure server connections
			timeout = 5*60*1000, -- Timeout in milliseconds
			temperature = 0,
			reasoning_effort = "high",
		},

		vendors = {
			["copilot1"] = {
				__inherited_from = "copilot",
				model = "claude-3.5-sonnet",
			},
			["copilot2"] = {
				__inherited_from = "copilot",
				model = "claude-3.7-sonnet",
			},
			["copilot3"] = {
				__inherited_from = "copilot",
				model = "claude-3.7-sonnet-thinking",
			},
			["copilot4"] = {
				__inherited_from = "copilot",
				model = "o3-mini",
				reasoning_effort = "low",
			},
		},
	},
	-- Build command for the plugin
	build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
			},
			file_types = { "markdown", "Avante" },
			ft = { "markdown", "Avante" },
		},
	},
}
