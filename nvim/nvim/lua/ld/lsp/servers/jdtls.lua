local jdtls = require("jdtls")
local utils = require("ld.utils.functions")
local root_markers = {".git"}
local root_dir = require("jdtls.setup").find_root(root_markers)
local home = os.getenv("HOME")
local workspace_folder = home .. "/.local/share/java/eclipse/" ..
                             vim.fn.fnamemodify(root_dir, ":p:h:t")
local java_bin = function() if utils.is_windows() then  return os.getenv("JAVA_HOME") .. "/bin/java" else return  home .. "/.local/share/java/17/bin/java" end end;
local configuration_path = function() if utils.is_windows() then return home .. "/.local/share/java/jdtls/config_win" else return home .. "/.local/share/java/jdtls/config_linux"end end

local get_runtimes = function() if utils.is_windows() then return {
        {name = "JavaSE-17", path = os.getenv("JAVA_HOME")},
}
else 
  return {
        {name = "JavaSE-11", path = home .. "/.local/share/java/11/"},
        {name = "JavaSE-17", path = home .. "/.local/share/java/17/"},
      }
end 
end
M = {}

config = {
  capabilities = require("ld.lsp.settings").capabilities,
  flags = {debounce_text_changes = 80, allow_incremental_sync = true},
  handlers = {},
}
-- mute; having progress reports is enough
-- config.handlers['language/status'] = function() end

config.settings = {
  java = {
    signatureHelp = {enabled = true},
    -- contentProvider = {preferred = 'fernflower'},
    -- completion = {
    --   favoriteStaticMembers = {
    --     "org.hamcrest.MatcherAssert.assertThat", "org.hamcrest.Matchers.*",
    --     "org.hamcrest.CoreMatchers.*", "org.junit.jupiter.api.Assertions.*",
    --     "java.util.Objects.requireNonNull",
    --     "java.util.Objects.requireNonNullElse", "org.mockito.Mockito.*"
    --   },
    --   filteredTypes = {
    --     "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*"
    --   }
    -- },
    sources = {
      organizeImports = {starThreshold = 9999, staticStarThreshold = 9999},
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      hashCodeEquals = {useJava7Objects = true},
      useBlocks = true,
    },
    configuration = {
      runtimes = get_runtimes()
    },
  },
}
config.cmd = {
 java_bin(),
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product", "-Dlog.protocol=true",
  "-Dlog.level=ALL", "-Xmx4g", "--add-modules=ALL-SYSTEM", "--add-opens",
  "java.base/java.util=ALL-UNNAMED", "--add-opens",
  "java.base/java.lang=ALL-UNNAMED", "-jar", vim.fn.glob(home ..
                                                             "/.local/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
  "-configuration",configuration_path(), "-data",
  workspace_folder,
}
config.on_attach = function(client, bufnr)
  require("ld.lsp.settings").on_attach(client, bufnr)

  -- require('ld.lsp.settings').on_attach(client, bufnr,
  --                                      {server_side_fuzzy_completion = true})

  -- jdtls.setup_dap({hotcodereplace = 'auto'})
  jdtls.setup.add_commands()
  local opts = {silent = true, buffer = bufnr}
  vim.keymap.set("n", "<A-o>", jdtls.organize_imports, opts)
  vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)
  vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
  vim.keymap.set("n", "crv", jdtls.extract_variable, opts)
  vim.keymap.set("v", "crm",
      [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
  vim.keymap.set("n", "crc", jdtls.extract_constant, opts)
  local create_command = vim.api.nvim_buf_create_user_command
  create_command(bufnr, "W", require("me.lsp.ext").remove_unused_imports,
      {nargs = 0})
end

local jar_patterns = {
  home .. "/.local/share/java/jdtls-extensions/vscode-java-debug/extension/server/com.microsoft.java.debug.plugin-*.jar",
 home .."/.local/share/java/jdtls-extensions/vscode-java-test/extension/server/*.jar", 
 home .."/.local/share/java/jdtls-extensions/vscode-pde-support/extension/server/*.jar", 
}
-- npm install broke for me: https://github.com/npm/cli/issues/2508
-- So gather the required jars manually; this is based on the gulpfile.js in the vscode-java-test repo
-- local bundle_list = vim.tbl_map(function(x)
--   return require("jdtls.path").join(plugin_path, x)
-- end, {
--   "org.eclipse.jdt.junit4.runtime_*.jar",
--   "org.eclipse.jdt.junit5.runtime_*.jar", "org.junit.jupiter.api*.jar",
--   "org.junit.jupiter.engine*.jar", "org.junit.jupiter.migrationsupport*.jar",
--   "org.junit.jupiter.params*.jar", "org.junit.vintage.engine*.jar",
--   "org.opentest4j*.jar", "org.junit.platform.commons*.jar",
--   "org.junit.platform.engine*.jar", "org.junit.platform.launcher*.jar",
--   "org.junit.platform.runner*.jar", "org.junit.platform.suite.api*.jar",
--   "org.apiguardian*.jar",
-- })
-- vim.list_extend(jar_patterns, bundle_list)
local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), "\n")) do
    if not vim.endswith(bundle,
        "com.microsoft.java.test.runner-jar-with-dependencies.jar") and
        not vim.endswith(bundle, "com.microsoft.java.test.runner.jar") then
      table.insert(bundles, bundle)
    end
  end
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities;
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
config.init_options = {
  bundles = bundles,
  extendedClientCapabilities = extendedClientCapabilities,
}

M.jdtls_start_or_attach = function()
  jdtls.start_or_attach(config)
end

return M
