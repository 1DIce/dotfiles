require("luasnip.session.snippet_collection").clear_snippets("lua")

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

ls.add_snippets("lua", {
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n $0\t\nend"),
  s(
    "req",
    fmt("local {} = require('{}')", {
      f(function(import_name)
        local parts = vim.split(import_name[1][1], ".", true)
        return parts[#parts] or ""
      end, { 1 }),
      i(1, "package_name"),
    })
  ),
}, { key = "lua" })
