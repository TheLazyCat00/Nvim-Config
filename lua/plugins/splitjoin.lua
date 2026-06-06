return {
	'Wansmer/treesj',
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	opts = function()
		local lang_utils = require("treesj.langs.utils")

		-- Only remove blank lines at the END (prevents extra blank line after split),
		-- but DO NOT trim leading blanks (they can be used to force a newline after `=`).
		local function trim_trailing_blank(lines)
			local last = #lines
			while last > 0 and (lines[last] or ""):match("^%s*$") do
				last = last - 1
			end
			local out = {}
			for i = 1, last do
				out[#out + 1] = lines[i]
			end
			return out
		end

		-- Split: normalize variant constructors so `|` is at line start,
		-- while preserving any leading blank line that TreeSJ emits.
		local function ocaml_variant_pipes_split_cleanup(lines)
			lines = trim_trailing_blank(lines)

			local out = {}
			for _, line in ipairs(lines) do
				local indent, rest = line:match("^(%s*)(.-)%s*$")
				-- Preserve empty/blank lines exactly (important for the first newline)
				if not rest or rest == "" then
					out[#out + 1] = line
				else
					rest = rest:gsub("%s*|%s*$", "") -- drop trailing |
					rest = rest:gsub("^|%s*", "")    -- drop leading | if already present
					out[#out + 1] = indent .. "| " .. rest
				end
			end

			return trim_trailing_blank(out)
		end

		-- Join: remove the first leading "|" and normalize spacing around all pipes.
		local function ocaml_variant_join_cleanup(lines)
			local s = table.concat(lines, "")

			s = s:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
			s = s:gsub("^|%s*", "")
			s = s:gsub("%s*|%s*", " | ")
			s = s:gsub("%s+", " "):gsub("%s+$", "")

			-- ensure exactly one leading space so `type t =` becomes `type t = Add ...`
			s = " " .. s:gsub("^%s+", "")

			return { s }
		end

		-- Records inside variant constructors: add one extra indent level after the "{"
		-- for ocamlformat-like hanging indent under `| Ctor of { ... }`.
		local function ocaml_indent_record_in_variant_constructor(lines, node)
			if not node or #lines < 2 then
				return lines
			end

			local sr, sc = node:range()
			local buf = 0
			local line = (vim.api.nvim_buf_get_lines(buf, sr, sr + 1, false)[1] or "")

			local prefix = line:sub(1, sc)
			if prefix:match("^%s*|") then
				local extra = (" "):rep(vim.fn.shiftwidth())
				for i = 2, #lines do
					lines[i] = extra .. lines[i]
				end
			end

			return lines
		end

		-- Enable `parenthesized_expression` only for tuple-ish parens: (a, b, ...)
		-- This prevents `(x)` from being split/joined.
		local function ocaml_is_tuple_parens(tsnode)
			for child in tsnode:iter_children() do
				if child:type() == "," then
					return true
				end
				-- Some grammars wrap tuple contents in a named node.
				if child:named() and child:type() == "tuple_expression" then
					return true
				end
			end
			return false
		end

		return {
			use_default_keymaps = false,
			max_join_length = 500,
			langs = {
				ocaml = {
					-- RECORDS ---------------------------------------------------------------
					record_expression = lang_utils.set_preset_for_dict({
						both = { separator = ";" },
						split = { last_separator = false },
					}),

					record_pattern = lang_utils.set_preset_for_dict({
						both = { separator = ";" },
						split = { last_separator = false },
					}),

					record_binding_pattern = lang_utils.set_preset_for_dict({
						both = { separator = ";" },
						split = { last_separator = false },
					}),

					record_declaration = lang_utils.set_preset_for_dict({
						both = { separator = ";" },
						split = {
							last_separator = false,
							format_resulted_lines = ocaml_indent_record_in_variant_constructor,
						},
					}),

					-- LISTS -----------------------------------------------------------------
					-- [a; b; c]
					list_expression = lang_utils.set_preset_for_list({
						both = { separator = ";" },
						split = { last_separator = false },
						join = { space_in_brackets = false },
					}),

					-- TUPLES via PARENS -----------------------------------------------------
					-- We format the outer node that actually owns the parentheses.
					-- This gives the nicer split:
					--   (
					--     "arg",
					--     map_seq ...
					--   );
					--
					-- and join back to:
					--   ("arg", map_seq ...);
					parenthesized_expression = lang_utils.set_preset_for_args({
						both = {
							enable = ocaml_is_tuple_parens,
						},
						join = {
							space_in_brackets = false,
						},
					}),

					-- Disable tuple_expression so TreeSJ doesn't pick it first and bypass
					-- parenthesized_expression.
					tuple_expression = { disable = true },

					-- VARIANTS --------------------------------------------------------------
					variant_declaration = lang_utils.set_preset_for_non_bracket({
						both = { separator = "|" },
						split = {
							last_separator = false,
							format_resulted_lines = ocaml_variant_pipes_split_cleanup,
						},
						join = {
							format_resulted_lines = ocaml_variant_join_cleanup,
						},
					}),

					-- REDIRECTS -------------------------------------------------------------
					type_binding = {
						target_nodes = { "record_declaration", "variant_declaration" },
					},
				},
			},
		}
	end,
	keys = {
		{ "gs", "<cmd>lua require('treesj').toggle()<CR>", mode = "n", desc = "Toggle split/join" },
	},
}
