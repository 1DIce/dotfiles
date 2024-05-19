local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
local present3, cmp = pcall(require, "cmp")

if not (present1 or present2 or present3) then
  return
end

autopairs.setup({
  check_ts = true,
  disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
  enable_bracket_in_quote = false,
})

local handlers = require("nvim-autopairs.completion.handlers")

cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done({
    filetypes = {
      -- "*" is a alias to all filetypes
      ["*"] = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          handler = handlers["*"],
        },
      },
    },
  })
)
