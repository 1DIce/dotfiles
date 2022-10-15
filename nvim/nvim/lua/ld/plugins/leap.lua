local leap = require("leap")

leap.setup({ case_sensitive = true })
leap.add_default_mappings()
nmap(
  "s",
  ":lua require('leap').leap { target_windows = { vim.fn.win_getid() } }<CR>",
  "Use leap on whole window"
)
