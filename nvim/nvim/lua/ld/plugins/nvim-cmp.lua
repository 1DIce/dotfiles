local present, cmp = pcall(require, "cmp")

if not present then
  return
end

cmp.setup({
  preselect = cmp.PreselectMode.None, -- avoid automatic selection of random lsp entry
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = {
      i = function()
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        else
          -- This workaround is currently needed to make sure that pressing <CR> still works normally while cmp is not visible
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n")
        end
      end,
    },
  },
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol",
      before = function(entry, vim_item)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snp]",
          buffer = "[Buf]",
          nvim_lua = "[Lua]",
          path = "[Path]",
        })[entry.source.name]

        return vim_item
      end,
    }),
  },
  sources = {
    { name = "nvim_lsp", max_item_count = 10 },
    { name = "luasnip", max_item_count = 10 },
    { name = "nvim_lua", max_item_count = 20 },
    { name = "path", max_item_count = 10 },
    { name = "buffer", max_item_count = 5, keyword_length = 4 },
  },
})

local cmdlineMappings = {
  ["<C-j>"] = {
    c = function()
      if cmp.visible() then
        cmp.select_next_item()
      end
    end,
  },
  ["<C-k>"] = {
    c = function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end,
  },
  ["<C-e>"] = {
    c = function()
      cmp.close()
    end,
  },
}

-- `/` cmdline setup.
cmp.setup.cmdline("/", { sources = { { name = "buffer", max_item_count = 15 } } })

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
  mapping = cmdlineMappings,
  sources = cmp.config.sources({
    -- {
    --   {name = "path", max_item_count = 15, keyword_length = 3},
    -- },
    {
      name = "cmdline",
      max_item_count = 30,
      keyword_pattern = [=[[^[:blank:]\!]*]=],
      keyword_length = 3,
    },
  }),
})
