local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")
local builtins = require("telescope.builtin")
local themes = require("telescope.themes")
local utils = require("ld.utils.functions")

local M = {}

M.search_config = function()
	require("telescope.builtin").find_files({
		prompt_title = "< VimConfig >",
		cwd = vim.fn.stdpath("config"),
	})
end

local lsp_location_result_to_key = function(lsp_result)
	local uri = lsp_result.uri
	local rangeStart = lsp_result.range.start
	local rangeEnd = lsp_result.range["end"]

	local ranges = {
		rangeStart.character,
		rangeStart.line,
		rangeEnd.character,
		rangeEnd.line,
	}
	local key = uri .. ":" .. table.concat(ranges, ":")
	return key
end

M.lsp_unique_references = function(opts)
	local params = vim.lsp.util.make_position_params()
	params.context = { includeDeclaration = true }

	local results_lsp, err = vim.lsp.buf_request_sync(0, "textDocument/references", params, opts.timeout or 10000)
	if err then
		vim.api.nvim_err_writeln("Error when finding references: " .. err)
		return
	end

	local locations = {}
	local hashSet = {}

	for _, server_results in pairs(results_lsp) do
		if server_results.result then
			local filtered_results = {}
			for _, result_entry in pairs(server_results.result) do
				if result_entry then
					local unique_key = lsp_location_result_to_key(result_entry)
					if hashSet[unique_key] ~= nil then
					-- Duplicate
					else
						table.insert(filtered_results, result_entry)
						hashSet[unique_key] = true
					end
				end
			end

			vim.list_extend(locations, vim.lsp.util.locations_to_items(filtered_results) or {})
		end
	end

	if vim.tbl_isempty(locations) then
		return
	end

	pickers
		.new(opts, {
			prompt_title = "LSP Unique References",
			finder = finders.new_table({
				results = locations,
				entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
			}),
			previewer = conf.qflist_previewer(opts),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

M.file_browser_home = function()
	require("telescope.builtin").file_browser({
		cwd = "~",
		depth = 1,
		hidden = true,
	})
end

M.buffers = function()
	require("telescope.builtin").buffers({})
end

M.find_files_angular_material = function()
	builtins.find_files(themes.get_ivy({
		prompt_title = "< Angular Material/CDK >",
		cwd = "$HOME/open-source/angular-cdk/",
		hidden = true,
		file_ignore_patterns = {
			".backup",
			".swap",
			".langservers",
			".session",
			".undo",
			"*.git",
			"node_modules",
			"vendor",
			".cache",
			".vscode-server",
			".Desktop",
			".Documents",
			"classes",
			"package-lock.json",
			".spec.ts",
		},
	}))
end

local escape_rg_text = function(text)
	text = text:gsub("%(", "\\%(")
	text = text:gsub("%)", "\\%)")
	text = text:gsub("%[", "\\%[")
	text = text:gsub("%]", "\\%]")
	text = text:gsub('"', '\\"')

	return text
end

M.live_grep_raw = function(opts, mode)
	local defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		auto_quoting = false,
		mappings = {
			i = {
				["<C-k>"] = require("telescope.actions").move_selection_previous,
			},
		},
	}
	opts = vim.tbl_extend("force", defaults, opts or {})
	opts.prompt_title = 'Live Grep Args (-t[ty] include, -T exclude -g"[!] [glob])"'
	if not opts.default_text then
		if mode == "v" then
			opts.default_text = '"' .. escape_rg_text(utils.get_visual_text()) .. '"'
		else
			-- opts.default_text = "\""
		end
	end

	require("telescope").extensions.live_grep_args.live_grep_raw(opts)
end

return M
