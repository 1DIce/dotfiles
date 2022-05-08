local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, autopairs_completion = pcall(require,
    "nvim-autopairs.completion.cmp")

if not (present1 or present2) then
  return
end

autopairs.setup({
  check_ts = true,
  disable_filetype = {"TelescopePrompt", "guihua", "guihua_rust", "clap_input"},
})
