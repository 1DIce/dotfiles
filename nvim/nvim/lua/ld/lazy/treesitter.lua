local function treesitter_config()
  local parsers = require("nvim-treesitter.parsers")
  local parser_configs = parsers.get_parser_configs()
  parser_configs.css.filetype_to_parsername = "less"
  parser_configs.jsonc.filetype_to_parsername = "json"

  vim.treesitter.language.register("groovy", "Jenkinsfile")

  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "astro",
      "angular",
      "typescript",
      "markdown",
      "lua",
      "jsonc",
      "css",
      "scss",
      "javascript",
      "html",
      "go",
      "bash",
      "toml",
      "yaml",
      "query",
      "java",
      "vim",
      "cpp",
      "groovy",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "plantuml" },
    },
    matchup = { enable = true },
    query_linter = {
      enable = false,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
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
    throttle = true,
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
      --   },
    },
  })
end

local function treesitter_textobjects_config()
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        -- The keymaps are defined in the configuration table, no way to get our Mapper in there !
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@call.outer",
          ["ic"] = "@call.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",

          -- xml attribute
          ["ax"] = "@attribute.outer",
          ["ix"] = "@attribute.inner",

          -- json
          ["ak"] = "@key.outer",
          ["ik"] = "@key.inner",
          ["av"] = "@value.outer",
          ["iv"] = "@value.inner",
        },
      },
      swap = {
        enable = true,
        swap_next = { ["<leader>rp"] = "@parameter.inner" },
        swap_previous = { ["<leader>rP"] = "@parameter.inner" },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
        goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "zi",
        node_incremental = "zi",
        scope_incremental = "zo",
        node_decremental = "zd",
      },
    },
    highlight = { enable = true },
  })

  local wk = require("which-key")

  wk.register({
    a = {
      f = { "Function outer motion" }, --
      c = { "call expression outer motion" },
      x = { "Attribute (html, xml) outer motion" },
      k = { "Json key outer motion" },
      v = { "Json value outer motion" },
      i = { "conditional outer moition" },
    },
    i = {
      f = { "Function inner motion" }, --
      c = { "call expression inner motion" }, --
      x = { "Attribute (html, xml) inner motion" },
      k = { "Json key inner motion" },
      v = { "Json value inner motion" },
      i = { "conditional inner moition" },
    },
    [" "] = {
      r = {
        p = { "Swap parameter to next" }, --
        P = { "Swap parameter to previous" },
      },
    },
    ["]"] = {
      m = { "Go to next function (start)" },
      M = { "Go to next function (end)" },
      ["]"] = { "Go to next class (start)" },
      ["["] = { "Go to next class (end)" },
    },
    ["["] = {
      m = { "Go to previous function (start)" },
      M = { "Go to previous function (end)" },
      ["["] = { "Go to previous class (start)" },
      ["]"] = { "Go to previous class (end)" },
    },
    z = {
      i = { "Init treesitter selection" },
      o = { "Expand scope (selection)" },
      I = { "Decrement scope (selection)" },
    },
  }, { mode = "o" })
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
  {

    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  "andymass/vim-matchup",
}
