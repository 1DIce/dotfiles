local M = {}

local default_language = "de-DE"

local function get_language(bufname)
  if require("ld.utils.functions").ends_with(bufname, "_de.properties") then
    return "de-DE"
  elseif require("ld.utils.functions").ends_with(bufname, ".properties") then
    return "en-US"
  else
    -- use auto detection
    return "auto"
  end
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost" }, {
    pattern = "*_de.properties",
    -- replace unicode escape sequences with actual characters
    command = [[ %s/\\u\(\x\{4\}\)/\=nr2char('0x'.submatch(1),1)/g ]],
  })

  vim.api.nvim_create_autocmd({ "BufWrite" }, {
    pattern = "*_de.properties",
    -- replace unicode escape sequences with actual characters
    command = [[ %s/\(ä\|ö\|ü\)/\="\\u" . printf("%04X",char2nr(submatch(1)))/g ]],
  })

  local lsp_config = {
    filetypes = { "jproperties", "markdown", "tex" },
    on_attach = function(client, bufnr)
      local bufnr = vim.api.nvim_get_current_buf()
      local bufname = vim.fn.bufname(bufnr)
      local language = get_language(bufname)
      client.config.settings.ltex.language = language
    end,
    settings = {
      ltex = {
        language = default_language,
        hiddenFalsePositives = {
          ["de-DE"] = { { rule = "WHITESPACE", sentence = "^.*=" } },
          -- ["en-US"] = {[[^.*=]],
        },
      },
    },
    single_file_support = true,
  }

  return lsp_config
end

return M
