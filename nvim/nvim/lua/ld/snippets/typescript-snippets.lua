require("luasnip.session.snippet_collection").clear_snippets("typescript")

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

ls.add_snippets("typescript", {
  s(
    "forof",
    fmt(
      [[
    for(const {} of {}) {{
      {}
    }}
  ]],
      {
        i(1, "element"),
        i(2, "elements"),
        i(0),
      }
    )
  ),

  s(
    "for",
    fmt(
      [[
    for(let {} = 0; {} < {}.length; {}++) {{
      {}
    }}
  ]],
      {
        i(1, "i"),
        rep(1),
        i(2, "array"),
        rep(1),
        i(0),
      }
    )
  ),

  s(
    "if",
    fmt(
      [[
    if({}) {{
      {}
    }}
  ]],
      {
        i(1),
        i(0),
      }
    )
  ),

  -- TODO adding a choise node to add more else if steps could be cool
  s(
    "ifelse",
    fmt(
      [[
    if({}) {{
      {}
    }} else {{
      {}
    }}
  ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),

  s(
    "it",
    fmt(
      [[
    it("should {}", () => {{
      {}
    }}),
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),

  -- TODO add option for nameOf??
  s(
    "describe",
    fmt(
      [[
    describe({}, () => {{
      {}
    }}),
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),

  s(
    "createAction",
    fmt(
      [[
                export const {} = createAction(
                PREFIX + "{}",
                {}
                )]],
      {
        f(function(actionDescription)
          local parts = vim.split(actionDescription[1][1], " ", true)
          table.insert(parts, "action")
          local capitalizedParts = {}
          for k, v in pairs(parts) do
            if k > 1 then
              capitalizedParts[k] = utils.firstToUpper(v)
            else
              capitalizedParts[k] = v
            end
          end
          return table.concat(capitalizedParts, "")
        end, { 1 }),
        i(1, "desciption"),
        d(2, function()
          return sn(nil, { c(1, { t(""), sn(nil, { t("props<{ "), i(1), t(" }>()") }) }) })
        end, {}),
      }
    )
  ),
}, { key = "typescript" })

-- TODO describe with ClassName.name or nameOf or string?
-- it
-- method choice node public
