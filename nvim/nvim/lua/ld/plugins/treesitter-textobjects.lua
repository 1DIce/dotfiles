require("nvim-treesitter.configs").setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      -- The keymaps are defined in the configuration table, no way to get our Mapper in there !
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

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
    c = { "Class outer motion" },
    x = { "Attribute (html, xml) outer motion" },
    k = { "Json key outer motion" },
    v = { "Json value outer motion" },
  },
  i = {
    f = { "Function inner motion" }, --
    c = { "Class inner motion" }, --
    x = { "Attribute (html, xml) inner motion" },
    k = { "Json key inner motion" },
    v = { "Json value inner motion" },
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
