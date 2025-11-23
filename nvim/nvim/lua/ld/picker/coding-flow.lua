local M = {}

local symbol_types_to_lsp_kinds = {
  type = "Class",
  ["function"] = "Function",
  variable = "Variable",
}

---
---@param language string programming language
---@param coding_flow_symbole_type string string representing coding-flow symbol type
---@param opts any
---@return nil
local function workspace_coding_flow_symbols(language, coding_flow_symbole_type, opts)
  opts = opts or {}

  local find_symbols = function(opts, ctx)
    local cwd = vim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or ".")
    return require("snacks.picker.source.proc").proc({
      opts,
      {
        cmd = "coding-flow",
        args = {
          "workspace-symbols",
          "--language",
          language,
          "--type",
          coding_flow_symbole_type,
        },
        transform = function(item)
          -- each item is a line of output from coding-flow
          -- expected format: "symbol_name<TAB>file_path<TAB>line_number<TAB>column_number"
          local parts = vim.split(item.text, "\t")

          local symbol_name = parts[1]
          local file_path_parts = vim.split(parts[2], ":")
          local file_path = file_path_parts[1]
          local line_number = file_path_parts[2]
          local column_number = file_path_parts[3]

          item.name = symbol_name
          item.lsp_kind = symbol_types_to_lsp_kinds[coding_flow_symbole_type] or "Unknown"
          item.kind = item.lsp_kind
          item.cwd = cwd
          item.file = file_path
          item.line = line_number
          item.col = column_number + 1
          -- item.pos is used for preview highlighting
          item.pos = { tonumber(line_number), column_number + 1 }
        end,
      },
    }, ctx)
  end

  local select_file = function(picker)
    picker:close()
    local item = picker:current()
    if not item then
      return
    end
    local parts = vim.split(item.text, "\t")
    local selected_file = parts[2]
    local file = require("fzf-lua").path.entry_to_file(selected_file)
    -- open file and go to cursor position afterwards
    vim.cmd("edit " .. item.file)
    pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(item.line), tonumber(item.col) - 1 })
  end

  Snacks.picker.pick({
    source = opts.prompt or "Workspace Types",
    finder = find_symbols,
    format = "lsp_symbol",
    confirm = select_file,
    preview = "file",
    workspace = true,
  })
end

function M.workspace_public_types(opts)
  opts = opts or {}
  if opts.prompt == nil then
    opts.prompt = "Workspace Types"
  end
  if require("ld.lsp.functions").is_typescript_workspace() then
    workspace_coding_flow_symbols("typescript", "type", opts)
  elseif require("ld.lsp.functions").is_python_workspace() then
    workspace_coding_flow_symbols("python", "type", opts)
  else
    require("fzf-lua").lsp_live_workspace_symbols(opts)
  end
end

function M.workspace_public_functions(opts)
  opts = opts or {}
  if opts.prompt == nil then
    opts.prompt = "Workspace Functions"
  end
  if require("ld.lsp.functions").is_typescript_workspace() then
    workspace_coding_flow_symbols("typescript", "function", opts)
  elseif require("ld.lsp.functions").is_python_workspace() then
    workspace_coding_flow_symbols("python", "function", opts)
  else
    require("telescope.builtin").lsp_workspace_symbols({ symbols = { "function" } })
  end
end

function M.workspace_public_variables(opts)
  opts = opts or {}
  if opts.prompt == nil then
    opts.prompt = "Workspace Variables"
  end
  if require("ld.lsp.functions").is_typescript_workspace() then
    workspace_coding_flow_symbols("typescript", "variable", opts)
  elseif require("ld.lsp.functions").is_python_workspace() then
    workspace_coding_flow_symbols("python", "variable", opts)
  else
    require("telescope.builtin").lsp_workspace_symbols({ symbols = { "variable" } })
  end
end

return M
