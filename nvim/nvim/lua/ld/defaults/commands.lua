vim.cmd(
    [[:command NgTestCur :Tkill | :T npm run test -- --include $(realpath --relative-to . %:p)]])

vim.cmd(
    [[:command DiffviewMrChange :lua require("ld.defaults.command).getDiffviewOriginalFilePath()]])
local M = {}
M.getDiffviewOriginalFilePath = function()
  local absolutePath = require("diffview.lib"):get_current_view()
                           :infer_cur_file().absolute_path
  if absolutePath then
    os.execute("gitlab-cli file-change " .. absolutePath .. " | xargs xdg-open")
  end
end

return M
