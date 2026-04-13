local function treesitter_config()
  require("nvim-treesitter").setup({})

  local ensure_installed = {
    "just",
    "python",
    "astro",
    "angular",
    "typescript",
    "markdown",
    "lua",
    "json5",
    "css",
    "scss",
    "javascript",
    "html",
    "go",
    "gomod",
    "bash",
    "toml",
    "yaml",
    "query",
    "java",
    "vim",
    "cpp",
    "groovy",
    "rust",
    "sql",
    "http",
    "terraform",
    "hcl",
    "kotlin",
  }
  local already_installed = require("nvim-treesitter.config").get_installed()
  local parsers_to_install = vim
    .iter(ensure_installed)
    :filter(function(parser)
      return not vim.tbl_contains(already_installed, parser)
    end)
    :totable()
  require("nvim-treesitter").install(parsers_to_install)

  vim.treesitter.language.register("json5", { "json", "jsonc" })
  vim.treesitter.language.register("groovy", "Jenkinsfile")
  vim.treesitter.language.register("bash", "dotenv")

  if require("ld.utils.path").is_dir("~/personal/tree-sitter-clickhouse-sql") then
    vim.treesitter.language.add("clickhouse_sql", {
      path = vim.fn.expand("~/personal/tree-sitter-clickhouse-sql/parser.so"),
      symbol_name = "clickhouse_sql",
    })
    vim.treesitter.language.register("clickhouse_sql", "clickhouse_sql")
  end

  vim.treesitter.language.register("angular", "angular.html") -- Register the filetype with treesitter for the `angular` language/parser

  local installed_parsers = require("nvim-treesitter.config").get_installed()
  local treesitter_filetypes = vim
    .iter(installed_parsers)
    :map(function(parser)
      return vim.treesitter.language.get_filetypes(parser)
    end)
    :flatten()
    :totable()
  table.insert(treesitter_filetypes, "clickhouse_sql")

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("ld-treesitter-feature-enable", { clear = true }),
    pattern = treesitter_filetypes,
    callback = function()
      -- Enable treesitter highlight
      vim.treesitter.start()

      -- Enable treesitter folds
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"

      -- Enable treesitter indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
  -- vim.api.nvim_set_hl(0, "@foo.bar", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@TypescriptTypeIdentifier", { link = "TSType" })
  vim.api.nvim_set_hl(0, "@TypescriptAccessibility", { link = "TSKeyword" })
  vim.api.nvim_set_hl(0, "@TypescriptImplements", { link = "TSKeyword" })
  vim.api.nvim_set_hl(0, "@TypescriptPredefinedType", { link = "TSTypeBuiltin" })
end

local function treesitter_context_config()
  require("treesitter-context").setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
      -- For all filetypes
      -- Note that setting an entry here replaces all other patterns for this entry.
      -- By setting the 'default' entry below, you can control which nodes you want to
      -- appear in the context window.
      default = {
        "function",
        "method",
        "for",
        "while",
        "if",
        "switch", -- These won't appear in the context
        -- 'case',
      },
      -- Example for a specific filetype.
      -- If a pattern is missing, *open a PR* so everyone can benefit.
      --   rust = {
      --       'impl_item',
      --   }
    },
  })
end

local function treesitter_textobjects_config()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  })

  local select = require("nvim-treesitter-textobjects.select")
  vim.keymap.set({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ac", function()
    select.select_textobject("@call.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ic", function()
    select.select_textobject("@call.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ai", function()
    select.select_textobject("@conditional.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ii", function()
    select.select_textobject("@conditional.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ax", function()
    select.select_textobject("@attribute.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ix", function()
    select.select_textobject("@attribute.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ak", function()
    select.select_textobject("@key.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ik", function()
    select.select_textobject("@key.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "av", function()
    select.select_textobject("@value.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "iv", function()
    select.select_textobject("@value.inner", "textobjects")
  end)

  local swap = require("nvim-treesitter-textobjects.swap")
  vim.keymap.set("n", "<leader>rp", function()
    swap.swap_next("@parameter.inner")
  end)
  vim.keymap.set("n", "<leader>rP", function()
    swap.swap_previous("@parameter.inner")
  end)

  local move = require("nvim-treesitter-textobjects.move")
  vim.keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]]", function()
    move.goto_next_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]M", function()
    move.goto_next_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "][", function()
    move.goto_next_end("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[M", function()
    move.goto_previous_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[]", function()
    move.goto_previous_end("@class.outer", "textobjects")
  end)

  local wk = require("which-key")

  wk.add({
    {
      mode = { "n", "x", "o" },
      { " rP", desc = "Swap parameter to previous" },
      { " rp", desc = "Swap parameter to next" },
      { "[M", desc = "Go to previous function (end)" },
      { "[[", desc = "Go to previous class (start)" },
      { "[]", desc = "Go to previous class (end)" },
      { "[m", desc = "Go to previous function (start)" },
      { "]M", desc = "Go to next function (end)" },
      { "][", desc = "Go to next class (end)" },
      { "]]", desc = "Go to next class (start)" },
      { "]m", desc = "Go to next function (start)" },
    },
  })

  wk.add({
    {
      mode = { "x", "o" },
      { "ac", desc = "call expression outer motion" },
      { "af", desc = "Function outer motion" },
      { "ai", desc = "conditional outer motion" },
      { "ak", desc = "Json key outer motion" },
      { "av", desc = "Json value outer motion" },
      { "ax", desc = "Attribute (html, xml) outer motion" },
      { "ic", desc = "call expression inner motion" },
      { "if", desc = "Function inner motion" },
      { "ii", desc = "conditional inner motion" },
      { "ik", desc = "Json key inner motion" },
      { "iv", desc = "Json value inner motion" },
      { "ix", desc = "Attribute (html, xml) inner motion" },
    },
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      vim.cmd([[TSUpdate]])
    end,
    config = function()
      treesitter_config()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      treesitter_context_config()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      treesitter_textobjects_config()
    end,
  },
}
