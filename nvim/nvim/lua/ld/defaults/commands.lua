vim.api.nvim_create_user_command("NgTestCur", function()
  vim.cmd(
      [[:Tkill | :T npm run test -- --include $(realpath --relative-to . %:p) ]])
end, {})

local getDiffviewOriginalFilePath = function()
  local absolutePath = require("diffview.lib"):get_current_view()
                           :infer_cur_file().absolute_path
  if absolutePath then
    os.execute("gitlab-cli file-change " .. absolutePath .. " | xargs xdg-open")
  end
end

vim.api.nvim_create_user_command("DiffviewMrChange",
    function() getDiffviewOriginalFilePath() end, {})
