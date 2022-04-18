local ls = require "luasnip"
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node;
local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep

local types = require("luasnip.util.types")

ls.config.set_config({
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,

  ext_opts = {[types.choiceNode] = {active = {virt_text = {{"<-", "Error"}}}}}
})

ls.add_snippets("all",
                {s("curtime", f(function() return os.date "%D - %H:%M" end))},
                {key = "all"})

ls.add_snippets("lua", {
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n $0\t\nend"),
  s("req", fmt("local {} = require('{}')", {
    f(function(import_name)
      local parts = vim.split(import_name[1][1], ".", true)
      return parts[#parts] or ""
    end, {1}), i(1, "package_name")
  }))
}, {key = "lua"})

-- TODO describe with ClassName.name or nameOf or string?
-- it
-- method choice node public 
--
-- ls.add_snippets("typescript", {}, {key = "typescript"})
