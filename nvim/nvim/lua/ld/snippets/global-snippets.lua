require("luasnip.session.snippet_collection").clear_snippets("all")

local ls = require("luasnip")
local utils = require("ld.utils.functions")
local fmt = require("luasnip.extras.fmt").fmt
-- Snipped Node
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local sn = ls.sn
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep

ls.add_snippets(
  "all",
  { s(
    "curtime",
    f(function()
      return os.date("%D - %H:%M")
    end)
  ) },
  { key = "all" }
)
