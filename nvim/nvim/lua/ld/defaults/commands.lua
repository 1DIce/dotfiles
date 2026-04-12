vim.api.nvim_create_user_command("NgTestCur", function()
  vim.cmd([[:Tkill | :T npm run test -- --include $(realpath --relative-to . %:p) ]])
end, {})

-- build angular App and fill the quickfix list with issues
vim.api.nvim_create_user_command("NgMake", function()
  vim.cmd(
    [[:setlocal makeprg=ng\ build | setlocal errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%# | :make ]]
  )
end, {})
--
-- run angular App test and fill the quickfix list with issues
vim.api.nvim_create_user_command("NgMakeTest", function()
  vim.cmd(
    [[:setlocal makeprg=ng\ test\ --configuration=ci\ --watch=false | setlocal errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%# | :make]]
  )
end, {})

local getDiffviewOriginalFilePath = function()
  local absolutePath = require("diffview.lib"):get_current_view():infer_cur_file().absolute_path
  if absolutePath then
    os.execute("gitlab-cli file-change " .. absolutePath .. " | xargs xdg-open")
  end
end

vim.api.nvim_create_user_command("DiffviewMrChange", function()
  getDiffviewOriginalFilePath()
end, {})

vim.api.nvim_create_user_command("GenUUID", function()
  local uuid = vim.cmd([[ system("uuidgen")]])
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. uuid .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
end, {})

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
  desc = "Show LSP Info",
})

vim.api.nvim_create_user_command("LspLog", function(_)
  local state_path = vim.fn.stdpath("state")
  local log_path = vim.fs.joinpath(state_path, "lsp.log")

  vim.cmd(string.format("edit %s", log_path))
end, {
  desc = "Show LSP log",
})

vim.api.nvim_create_user_command("LspRestart", "lsp restart", {
  desc = "Restart LSP",
})

vim.api.nvim_create_user_command("LspToggleInlayHints", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {})

vim.api.nvim_create_user_command("Notifications", function()
  Snacks.notifier.show_history()
end, {})

vim.api.nvim_create_user_command("CompareToClipboard", function()
  local setup_current_buffer = function(name, lines)
    vim.cmd.edit(name)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.buftype = "nofile"
    vim.bo.buflisted = false
    vim.cmd.diffthis()
  end
  local current_buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Get all lines in the current buffer
  vim.cmd.tabnew()
  setup_current_buffer("original", current_buf_lines)

  -- open vertial split
  local register_name = "+"
  vim.cmd.vnew()
  local register_lines = {}
  for line in vim.fn.getreg(register_name):gmatch("[^\n]+") do
    table.insert(register_lines, line)
  end
  setup_current_buffer("clipboard_content", register_lines)
end, {})

vim.api.nvim_create_user_command("ClaudeCommit", function(args)
  local diff = vim.fn.system({ "git", "diff", "--staged" })
  if diff == "" then
    vim.notify("No staged changes", vim.log.levels.WARN)
    return
  end

  local prompt = table.concat({
    "Write a git commit message following Conventional Commits format:",
    "",
    "  <type>(optional scope): <description>",
    "",
    "  [optional body]",
    "",
    "Rules:",
    "- Subject line: imperative mood, present tense, active voice, max 72 chars",
    "- Type: feat|fix|refactor|docs|test|build|ci|chore",
    "- Body: wrap at 72 chars; explain what the change accomplishes and why, not how",
    "- Body lines: bullet points starting with '- '",
    "- Be succinct but not terse; don't assume implicit context",
    "- Focus on the most important changes",
    "- Output only the commit message, no commentary",
  }, "\n")

  local wip_context = ""
  if args.range == 2 then
    local selected = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false)
    wip_context = table.concat(selected, "\n")
  elseif args.args and args.args ~= "" then
    wip_context = args.args
  end
  if wip_context ~= "" then
    prompt = prompt .. "\n\nWIP context:\n" .. wip_context
  end
  prompt = prompt .. "\n\nStaged diff:\n" .. diff

  local output = {}
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart({ "claude", "--model", "haiku", "--print", prompt }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_exit = function()
      vim.schedule(function()
        while #output > 0 and output[#output] == "" do
          table.remove(output)
        end
        if #output == 0 then
          vim.notify("ClaudeCommit: no output from claude", vim.log.levels.ERROR)
          return
        end
        vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, output)
      end)
    end,
  })
  vim.notify("ClaudeCommit: generating...", vim.log.levels.INFO)
end, {
  nargs = "?",
  range = true,
  desc = "Generate commit message via Claude Haiku from staged diff",
})

vim.api.nvim_create_user_command("PytonFormatBuf", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Get all lines in the current buffer
  local single_line = table.concat(lines, "") -- Join all lines
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { single_line }) -- Replace buffer content with the single line
  vim.cmd("%! ruff format -")
end, {})
