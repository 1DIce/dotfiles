vim.cmd(
    [[:command NgTestCur :Tkill | :T npm run test -- --include $(realpath --relative-to . %:p)]])
