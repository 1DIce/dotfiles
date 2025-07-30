local null_ls = require("null-ls")

null_ls.setup({
  on_attach = function(client, bufnr)
    require("ld.lsp.remaps").set_default(client, bufnr)
  end,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.yamllint.with({
      disabled_filetypes = { "helm" },
      cwd = function()
        return vim.uv.cwd()
      end,
    }),
    null_ls.builtins.formatting.prettierd,
  },
  debounce = 600,
})
