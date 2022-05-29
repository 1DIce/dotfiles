local ls = require "luasnip"

vim.keymap.set({"i", "s"}, "<c-n>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<c-m>", function()
  if ls.expand_or_jumpable(-1) then
    ls.jump(-1)
  end
end, {silent = true})

vim.keymap.set({"i"}, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {silent = true})

-- Execute "On the fly" snippets. Save a snippet to a register
-- and exeute it in insert mode with <c-q>register_name
local create_snipped_on_the_fly_keymap = function(register)
  vim.keymap.set({"i"}, "<c-q>" .. register, function()
    require("luasnip.extras.otf").on_the_fly(register)
  end)
end

create_snipped_on_the_fly_keymap("a")
create_snipped_on_the_fly_keymap("b")
create_snipped_on_the_fly_keymap("c")
create_snipped_on_the_fly_keymap("d")
create_snipped_on_the_fly_keymap("e")
create_snipped_on_the_fly_keymap("f")
create_snipped_on_the_fly_keymap("g")
create_snipped_on_the_fly_keymap("h")
create_snipped_on_the_fly_keymap("i")
create_snipped_on_the_fly_keymap("j")
create_snipped_on_the_fly_keymap("k")
create_snipped_on_the_fly_keymap("l")
create_snipped_on_the_fly_keymap("m")
create_snipped_on_the_fly_keymap("n")
create_snipped_on_the_fly_keymap("o")
create_snipped_on_the_fly_keymap("p")
create_snipped_on_the_fly_keymap("q")
create_snipped_on_the_fly_keymap("r")
create_snipped_on_the_fly_keymap("s")
create_snipped_on_the_fly_keymap("t")
create_snipped_on_the_fly_keymap("u")
create_snipped_on_the_fly_keymap("v")
create_snipped_on_the_fly_keymap("w")
create_snipped_on_the_fly_keymap("x")
create_snipped_on_the_fly_keymap("y")
create_snipped_on_the_fly_keymap("z")
