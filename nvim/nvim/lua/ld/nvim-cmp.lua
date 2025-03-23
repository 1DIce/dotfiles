local path_util = require("ld.utils.path")
local present, cmp = pcall(require, "cmp")

if not present then
  return
end

-- Until https://github.com/hrsh7th/nvim-cmp/issues/1716
-- (cmp.ConfirmBehavior.MatchSuffix) gets implemented, use this local wrapper
-- to choose between `cmp.ConfirmBehavior.Insert` and
-- `cmp.ConfirmBehavior.Replace`:
local confirm = function(entry)
  local behavior = cmp.ConfirmBehavior.Replace
  if entry then
    local completion_item = entry.completion_item
    local newText = ""
    if completion_item.textEdit then
      newText = completion_item.textEdit.newText
    elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
      newText = completion_item.insertText
    else
      newText = completion_item.word or completion_item.label or ""
    end

    -- How many characters will be different after the cursor position if we
    -- replace?
    local diff_after = math.max(0, entry.replace_range["end"].character + 1)
      - entry.context.cursor.col

    -- Does the text that will be replaced after the cursor match the suffix
    -- of the `newText` to be inserted? If not, we should `Insert` instead.
    if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
      behavior = cmp.ConfirmBehavior.Insert
    end
  end
  cmp.confirm({ select = true, behavior = behavior })
end

cmp.setup({
  preselect = cmp.PreselectMode.None, -- avoid automatic selection of random lsp entry
  -- custom enabled function to make cmp-dap completions work
  enabled = function()
    return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
      or require("cmp_dap").is_dap_buffer()
  end,
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
          local entry = cmp.get_selected_entry()
          confirm(entry)
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
      max_item_count = 100,
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

  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
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
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmdlineMappings,
  sources = { { name = "buffer", max_item_count = 15 } },
})

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
