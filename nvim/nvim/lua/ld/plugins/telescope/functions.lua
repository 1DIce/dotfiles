local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local make_entry = require('telescope.make_entry')

local M = {}

M.search_config = function()
  require("telescope.builtin").find_files({prompt_title = "< VimConfig >", cwd = "$HOME/.config/nvim"})
end

local lsp_location_result_to_key = function(lsp_result)
  local uri = lsp_result.uri
  local rangeStart = lsp_result.range.start
  local rangeEnd = lsp_result.range["end"]

  local ranges = {rangeStart.character, rangeStart.line, rangeEnd.character, rangeEnd.line}
  local key = uri .. ":" .. table.concat(ranges, ":")
  return key

end

M.lsp_unique_references = function(opts)
  local params = vim.lsp.util.make_position_params()
  params.context = {includeDeclaration = true}

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

  if vim.tbl_isempty(locations) then return end

  pickers.new(opts, {
    prompt_title = "LSP Unique References",
    finder = finders.new_table {
      results = locations,
      entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts)
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts)
  }):find()
end

return M
