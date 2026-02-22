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
	{ "ms-jpq/coq.thirdparty", branch = "3p" }
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
				exclude = {}, -- filetypes for which you don"t want to enable inlay hints
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
				["*"] = {
					capabilities = {
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					},
					keys = {
						{ "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
						{ "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
						{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
						{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
						{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
						{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
						{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
						{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
						{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
						{ "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },

						{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
						{ "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
						{ "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
						{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
						{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
						{ "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
						{ "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
							desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
						{ "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
							desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
						{ "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
							desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
						{ "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
							desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = true,
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
								paramName = "All",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							diagnostics = {
								disable = { "unused-function" }
							},
						},
					},
				},
				ts_ls = {
					name = "tsserver",
					cmd = { "typescript-language-server", "--stdio" },
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
				},
				volar = {
					filetypes = { "vue" },
					init_options = {
						vue = {
							hybridMode = true,
						},
					},
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--log=verbose",
						"--header-insertion=iwyu",
						"--experimental-modules-support"
					},
					init_options = {
						fallbackFlags = {
							"-std=c++23",
							"-Wall",
							"-Wextra",
							"-pedantic",
						},
					},
				},
				html = {},
				cssls = {},
				omnisharp = {
					cmd = {
						"omnisharp",
						"-z",
						"--hostPID",
						"12345",
						"DotNet:enablePackageRestore=false",
						"--encoding",
						"utf-8",
						"--languageserver",

						"RoslynExtensionsOptions:inlayHintsOptions:enableForParameters=true",
						"RoslynExtensionsOptions:inlayHintsOptions:forLiteralParameters=true",
						"RoslynExtensionsOptions:inlayHintsOptions:forIndexerParameters=true",
						"RoslynExtensionsOptions:inlayHintsOptions:forObjectCreationParameters=true",
						"RoslynExtensionsOptions:inlayHintsOptions:forOtherParameters=true",
						"RoslynExtensionsOptions:inlayHintsOptions:suppressForParametersThatDifferOnlyBySuffix=false",
						"RoslynExtensionsOptions:inlayHintsOptions:suppressForParametersThatMatchMethodIntent=false",
						"RoslynExtensionsOptions:inlayHintsOptions:suppressForParametersThatMatchArgumentName=true",
						"RoslynExtensionsOptions:inlayHintsOptions:enableForTypes=true",
						"RoslynExtensionsOptions:inlayHintsOptions:forImplicitVariableTypes=true",
						"RoslynExtensionsOptions:inlayHintsOptions:forLambdaParameterTypes=true",
						"RoslynExtensionsOptions:inlayHintsOptions:forImplicitObjectCreation=true",
					},
				},
				jsonls = {},
				cmake = {},
				julials = {
					root_markers = { "Project.toml", "JuliaProject.toml", "Manifest.toml" }
				},
				serve_d = {
					cmd = {
						"C:/D/serve-d/serve-d.exe",
						"--provide", "implement-snippets",
						"--provide", "context-snippets",
						"--provide", "default-snippets"
					}
				},
				dartls = {
					settings = {
						dart = {
							completeFunctionCalls = false,
							inlayHints = {
								dotShorthandTypes = true,
								parameterNames = "all",
								parameterTypes = false,
								returnTypes = false,
								typeArguments = false,
								variableTypes = false,
							}
						}
					}
				},
				rust_analyzer = {},
				gopls = {
					settings = {
						gopls = {
							hints = {
								parameterNames = true
							}
						}
					}
				},
				bashls = {},
				ty = {}
			},
			-- you can do any additional lsp server setup here
			-- return true if you don"t want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				julials = function(_, opts)
					vim.lsp.config("julials", opts)
					vim.lsp.enable("julials")
					return true
				end,
			}
		}
		return ret
	end,
}
