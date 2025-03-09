return {
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		-- Not all LSP servers add brackets when completing a function.
		-- To better deal with this, LazyVim adds a custom option to cmp,
		-- that you can configure. For example:
		--
		-- ```lua
		-- opts = {
		--   auto_brackets = { "python" }
		-- }
		-- ```
		opts = function(_, opts)
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			local auto_select = true
			local lspkind = require('lspkind')

			return {
				auto_brackets = {}, -- configure any filetype to auto add brackets
				completion = {
					completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
				},
				preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
					["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
					["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-CR>"] = function(fallback)
						cmp.abort()
						fallback()
					end,
					["<tab>"] = function(fallback)
						return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
					end,
				}),
				sources = cmp.config.sources({
					{ name = "lazydev" },
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
						{ name = "buffer" },
					}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = {
							-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
							-- can also be a function to dynamically calculate max width such as
							-- menu = function() return math.floor(0.45 * vim.o.columns) end,
							menu = 50, -- leading text (labelDetails)
							abbr = 50, -- actual suggestion item
						},
						ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default

						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						before = function (entry, vim_item)
							-- ...
							return vim_item
						end
					}),
					experimental = {
						-- only show ghost text when we show ai completions
						ghost_text = vim.g.ai_cmp and {
							hl_group = "CmpGhostText",
						} or false,
					},
				},
				sorting = defaults.sorting,
			}
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		optional = true,
		dependencies = { -- this will only be evaluated if nvim-cmp is enabled
			{
				"zbirenbaum/copilot-cmp",
				opts = {},
				config = function(_, opts)
					local copilot_cmp = require("copilot_cmp")
					copilot_cmp.setup(opts)
					-- attach cmp source whenever copilot attaches
					-- fixes lazy-loading issues with the copilot cmp source
					LazyVim.lsp.on_attach(function()
						copilot_cmp._on_insert_enter({})
					end, "copilot")
				end,
				specs = {
					{
						"hrsh7th/nvim-cmp",
						optional = true,
						---@param opts cmp.ConfigSchema
						opts = function(_, opts)
							table.insert(opts.sources, 1, {
								name = "copilot",
								group_index = 1,
								priority = 100,
							})
						end,
					},
				},
			},
		},
	}
}
