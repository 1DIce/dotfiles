local function keymap(mode, input, output, description, opts, bufnr)
  if opts == nil then
    opts = {}
  end

  if type(output) == "function" then
    opts = vim.tbl_extend("keep", opts, {callback = output})
    output = nil
  end

  opts = vim.tbl_extend("force", opts, {desc = description})

  if bufnr == nil then
    vim.api.nvim_set_keymap(mode, input, output, opts)
  else
    vim.api.nvim_buf_set_keymap(bufnr, mode, input, output, opts)
  end

end

local function noremap(mode, input, output, description, opts)
  if opts == nil then
    opts = {}
  end
  opts = vim.tbl_extend("force", opts, {noremap = true})
  keymap(mode, input, output, description, opts)
end

function bufnoremap(bufnr, mode, input, output, description, opts)
  if opts == nil then
    opts = {}
  end
  opts = vim.tbl_extend("keep", opts, {noremap = true, silent = true})
  keymap(mode, input, output, description, opts, bufnr)
end

function nnoremap(input, output, description, opts)
  noremap("n", input, output, description, opts)
end

function inoremap(input, output, description, opts)
  noremap("i", input, output, description, opts)
end

function vnoremap(input, output, description, opts)
  noremap("v", input, output, description, opts)
end

function xnoremap(input, output, description, opts)
  noremap("x", input, output, description, opts)
end

function onoremap(input, output, description, opts)
  noremap("o", input, output, description)
end

function tnoremap(input, output, description, opts)
  noremap("t", input, output, description, opts)
end

function cnoremap(input, output, description, opts)
  noremap("c", input, output, description, opts)
end

function nmap(input, output, description, opts)
  keymap("n", input, output, description, opts)
end

function imap(input, output, description, opts)
  keymap("i", input, output, description, opts)
end

function vmap(input, output, description, opts)
  keymap("v", input, output, description, opts)
end

function xmap(input, output, description, opts)
  keymap("x", input, output, description, opts)
end

function omap(input, output, description, opts)
  keymap("o", input, output, description)
end

function tmap(input, output, description, opts)
  keymap("t", input, output, description, opts)
end
