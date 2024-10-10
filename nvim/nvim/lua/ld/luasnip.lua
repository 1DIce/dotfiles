local ls = require("luasnip")

local types = require("luasnip.util.types")

ls.config.set_config({
  history = true,
  update_events = "TextChanged,TextChangedI,InsertLeave",
  enable_autosnippets = false,

  ext_opts = { [types.choiceNode] = { active = { virt_text = { { "<- ChoiceNode", "Error" } } } } },
})

-- Loading all snippets from directory
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/ld/snippets/*.lua", true)) do
  loadfile(ft_path)()
end

-- Loading snippets from go.nvim directory
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snips/go.lua", false)) do
  loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-J>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-K>", function()
  if ls.expand_or_jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "i" }, "<c-L>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
