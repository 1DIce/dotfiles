return {
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("ld.luasnip")
    end,
    build = "make install_jsregexp",
  },
}
