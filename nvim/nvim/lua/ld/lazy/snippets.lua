return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "ray-x/go.nvim" },
    config = function()
      require("ld.luasnip")
    end,
    build = "make install_jsregexp",
  },
}
