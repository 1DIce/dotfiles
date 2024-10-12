local path_util = require("ld.utils.path")
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

  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = {
      i = function(fallback)
        local cmp = require("cmp")
        local filetype = vim.bo.filetype
        if filetype == "DressingInput" or filetype == "sagarename" then
          -- call the overriden mapping from dressing.nvim otherwise we would insert a new line
          fallback()
        end
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
  }),
  ---@diagnostic disable-next-line: missing-fields
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
          jenkinsfile = "[Jenkins]",
          ["vim-dadbod-completion"] = "[SQL]",
        })[entry.source.name]

        return vim_item
      end,
    }),
  },
  sources = {
    {
      name = "nvim_lsp",
      max_item_count = 50,
      entry_filter = function(entry, ctx)
        if ctx.filetype == "rust" then
          local item = entry.completion_item
          if
            item.kind == 15 -- kind 15 == "Snippet"
            and item.filterText == "call"
          then
            -- filter out rust lsp call expression snippet because it bugs out alot
            return false
          end
        end
        -- returning true will keep the entry
        return true
      end,
    },
    { name = "luasnip", max_item_count = 10 },
    { name = "async_path", max_item_count = 10 },
    { name = "buffer", max_item_count = 5, keyword_length = 4 },
  },
})

if not vim.g.started_by_firenvim then
  cmp.setup.filetype("Jenkinsfile", {
    sources = {
      {
        name = "jenkinsfile",
        option = {
          gdsl_file = path_util.to_os_path(
            os.getenv("HOME") .. "/dotfiles/merlin/jenkins-pipeline-syntax-gdsl"
          ),
        },
      },
      { name = "buffer", max_item_count = 5, keyword_length = 4 },
    },
  })

  cmp.setup.filetype("lua", {
    sources = {
      { name = "nvim_lsp", max_item_count = 50 },
      {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      },
      { name = "luasnip", max_item_count = 10 },
      { name = "nvim_lua", max_item_count = 20 },
      { name = "buffer", max_item_count = 5, keyword_length = 4 },
    },
  })

  cmp.setup.filetype({ "sql" }, {
    sources = {
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    },
  })
end

local cmdlineMappings = {
  ["<C-p>"] = {
    c = function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end,
  },
  ["<C-n>"] = {
    c = function()
      if cmp.visible() then
        cmp.select_next_item()
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
      option = {
        ignore_cmds = { "Man", "!", "grep", "vimgrep" },
      },
      --
      -- max_item_count = 30,
      -- keyword_pattern = [=[[^[:blank:]\!]*]=],
      -- keyword_length = 3,
    },
  }),
})
