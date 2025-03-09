return {
	"neovim/nvim-lspconfig",
	event = "LazyFile",
	dependencies = {
		"mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
	},
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
				exclude = {  }, -- filetypes for which you don't want to enable inlay hints
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = false,
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
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
				ts_ls = {
					filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
					init_options = {
						plugins = {
							{
								name = '@vue/typescript-plugin',
								location = require('mason-registry').get_package('vue-language-server'):get_install_path() ..
									'/node_modules/@vue/language-server',
								languages = { 'vue' },
							},
						},
					},
					handlers = {
						['_typescript.rename'] = function(_, result)
							return result
						end,
						['textDocument/definition'] = function(err, result, ...)
							result = vim.islist(result) and result[1] or result
							vim.lsp.handlers['textDocument/definition'](err, result, ...)
						end,
					},
				},
				volar = {
					filetypes = { 'vue' },
					init_options = {
						vue = {
							hybridMode = true,
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								disableTypeCheckingForAny = true,
							},
						},
					},
				},
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
				tsserver = function(_, opts)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
		}
		local keys = require("lazyvim.plugins.lsp.keymaps").get()
		keys[#keys + 1] = { "<C-k>", false, mode = "i" }
		return ret
	end,
	---@param opts PluginLspOpts
	config = function(_, opts)
		-- Setup Julia LSP with its original configuration first
		-- Create specialized Julia capabilities function
		local function create_capabilities()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.completion.completionItem.preselectSupport = true
			capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
			capabilities.textDocument.completion.completionItem.deprecatedSupport = true
			capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
			capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
			capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
			capabilities.textDocument.completion.completionItem.resolveSupport = {
				properties = { "documentation", "detail", "additionalTextEdits" },
			}
			capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown" }
			capabilities.textDocument.codeAction = {
				dynamicRegistration = true,
				codeActionLiteralSupport = {
					codeActionKind = {
						valueSet = (function()
							local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
							table.sort(res)
							return res
						end)(),
					},
				},
			}
			return capabilities
		end

		-- Set up Julia LSP directly as in the original config
		local on_attach = function(client, bufnr)
			-- Use the default attach function first
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

			-- Add any Julia-specific keybindings here if needed
		end

		-- Set up Julia LSP server directly using the original approach
		require("lspconfig").julials.setup({
			on_attach = on_attach,
			capabilities = create_capabilities(),
		})

		-- Continue with LazyVim's standard LSP setup for other languages
		LazyVim.format.register(LazyVim.lsp.formatter())

		LazyVim.lsp.on_attach(function(client, buffer)
			require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
		end)

		LazyVim.lsp.setup()
		LazyVim.lsp.on_dynamic_capability(require("lazyvim.plugins.lsp.keymaps").on_attach)

		if vim.fn.has("nvim-0.10.0") == 0 then
			if type(opts.diagnostics.signs) ~= "boolean" then
				for severity, icon in pairs(opts.diagnostics.signs.text) do
					local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
					name = "DiagnosticSign" .. name
					vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
				end
			end
		end

		if vim.fn.has("nvim-0.10") == 1 then
			-- inlay hints
			if opts.inlay_hints.enabled then
				LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
					if
						vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end)
			end

			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = buffer,
						callback = vim.lsp.codelens.refresh,
					})
				end)
			end
		end

		if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
			opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
			or function(diagnostic)
				local icons = LazyVim.config.icons.diagnostics
				for d, icon in pairs(icons) do
					if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
						return icon
					end
				end
			end
		end

		-- Apply global diagnostics config (will be overridden for Julia via the handler)
		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

		local servers = opts.servers
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		local has_blink, blink = pcall(require, "blink.cmp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp and cmp_nvim_lsp.default_capabilities() or {},
			has_blink and blink.get_lsp_capabilities() or {},
			opts.capabilities or {}
		)

		local function setup(server)
			-- Skip julials since we set it up separately
			if server == "julials" then
				return
			end

			local server_opts = vim.tbl_deep_extend("force", {
				capabilities = vim.deepcopy(capabilities),
			}, servers[server] or {})
			if server_opts.enabled == false then
				return
			end

			if opts.setup[server] then
				if opts.setup[server](server, server_opts) then
					return
				end
			elseif opts.setup["*"] then
				if opts.setup["*"](server, server_opts) then
					return
				end
			end
			require("lspconfig")[server].setup(server_opts)
		end

		-- get all the servers that are available through mason-lspconfig
		local have_mason, mlsp = pcall(require, "mason-lspconfig")
		local all_mslp_servers = {}
		if have_mason then
			all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
		end

		local ensure_installed = {} ---@type string[]
		for server, server_opts in pairs(servers) do
			if server_opts and server ~= "julials" then -- Skip julials
				server_opts = server_opts == true and {} or server_opts
				if server_opts.enabled ~= false then
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end
		end

		if have_mason then
			mlsp.setup({
				ensure_installed = vim.tbl_deep_extend(
					"force",
					ensure_installed,
					LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
				),
				handlers = { setup },
			})
		end

		if LazyVim.lsp.is_enabled("denols") and LazyVim.lsp.is_enabled("vtsls") then
			local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
			LazyVim.lsp.disable("vtsls", is_deno)
			LazyVim.lsp.disable("denols", function(root_dir, config)
				if not is_deno(root_dir) then
					config.settings.deno.enable = false
				end
				return false
			end)
		end
	end,
}
