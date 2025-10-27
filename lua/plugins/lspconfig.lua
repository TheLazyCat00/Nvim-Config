local standard = {
	"mason.nvim",
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			automatic_installation = true,
		},
		config = function() end,
	},
}

local coqDeps = {
	-- INFO: coq
	-- main one
	{ "ms-jpq/coq_nvim", branch = "coq" },

	-- 9000+ Snippets
	{ "ms-jpq/coq.artifacts", branch = "artifacts" },

	-- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
	-- Need to **configure separately**
	{ 'ms-jpq/coq.thirdparty', branch = "3p" }
	-- - shell repl
	-- - nvim lua api
	-- - scientific calculator
	-- - comment banner
	-- - etc
}

return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = (function ()
		if vim.g.lazyvim_cmp == "coq_nvim" then
			return vim.tbl_extend("force", standard, coqDeps)
		else
			return standard
		end
	end)(),
	opts = function()
		---@class PluginLspOpts
		local ret = {
			-- options for vim.diagnostic.config()
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					-- prefix = "icons",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
					},
				},
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = true,
				exclude = {}, -- filetypes for which you don't want to enable inlay hints
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = false,
			},

			folds = {
				enabled = true,
			},
			-- add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "All", -- Show parameter names
								semicolon = "Disable", -- Show semicolon hints
								arrayIndex = "Disable", -- Show array index hints
							},
							diagnostics = {
								disable = { "unused-function" }
							},
						},
					},
				},
				ts_ls = {
					name = "tsserver",
					cmd = { 'typescript-language-server', '--stdio' },
					filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
				},
				volar = {
					filetypes = { 'vue' },
					init_options = {
						vue = {
							hybridMode = true,
						},
					},
				},
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "basic",
								disableTypeCheckingForAny = true,
								inlayHints = {
									variableTypes = false,
									callArgumentNames = true,
									functionReturnTypes = false,
									genericTypes = false,
								}
							},
						}
					}
				},
				clangd = {
					cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
					init_options = {
						fallbackFlags = {
							'-std=c++23',
							'-Wall',
							'-Wextra',
							'-pedantic',
						},
					},
				},
				html = {},
				cssls = {},
				omnisharp = {},
				jsonls = {},
				cmake = {},
				-- Explicitly exclude julials from LazyVim management
				julials = {
					mason = false, -- Don't manage julia through mason
					enabled = false, -- Don't set up through standard LazyVim mechanism
				},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
			},
		}
		return ret
	end,
}
