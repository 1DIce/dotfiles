require("luasnip.session.snippet_collection").clear_snippets("python")

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

ls.add_snippets("python", {
  ls.parser.parse_snippet("def", "def $1($2) -> $3: \n\t$0"),
}, { key = "python" })
