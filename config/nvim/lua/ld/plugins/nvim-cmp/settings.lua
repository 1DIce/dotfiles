local present, cmp = pcall(require, 'cmp')

if not present then return end

cmp.setup({
  experimental = {native_menu = false},
  snippet = {expand = function(args) require('luasnip').lsp_expand(args.body) end},
  mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
    -- ['<Tab>'] = function(fallback)
    --     if cmp.visible() then
    --         cmp.select_next_item()
    --     elseif require('luasnip').expand_or_jumpable() then
    --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
    --                             '<Plug>luasnip-expand-or-jump', true, true,
    --                             true), '')
    --     else
    --         fallback()
    --     end
    -- end,
    -- ['<S-Tab>'] = function(fallback)
    --     if cmp.visible() then
    --         cmp.select_prev_item()
    --     elseif require('luasnip').jumpable(-1) then
    --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
    --                             '<Plug>luasnip-jump-prev', true, true, true),
    --                         '')
    --     else
    --         fallback()
    --     end
    -- end
  },
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require('lspkind').presets.default[vim_item.kind] .. ' ' .. vim_item.kind

      -- set a name for each source
      vim_item.menu =
          ({nvim_lsp = '[LSP]', luasnip = '[Snp]', buffer = '[Buf]', nvim_lua = '[Lua]', path = '[Path]'})[entry.source
              .name]

      return vim_item
    end
  },
  sources = {
    {name = 'nvim_lsp', max_item_count = 10}, {name = 'luasnip', max_item_count = 10}, {name = 'nvim_lua'},
    {name = 'path'}, {name = 'buffer'}
  }
})
