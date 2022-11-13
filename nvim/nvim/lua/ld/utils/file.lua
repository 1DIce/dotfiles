local M = {}

function M.write_file(path, contents)
  local fd = assert(vim.loop.fs_open(path, "w", 438))
  vim.loop.fs_write(fd, contents, -1)
  assert(vim.loop.fs_close(fd))
end

return M
