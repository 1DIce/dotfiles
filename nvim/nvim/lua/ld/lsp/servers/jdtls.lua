local path = require("lspconfig.util").path
local jdtls = require("jdtls")
local execute_command = require("jdtls.util").execute_command
local utils = require("ld.utils.functions")

local root_markers = { ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local home = vim.fn.getenv("HOME")

local function progress_report(_, result, ctx)
  local lsp = vim.lsp
  local info = {
    client_id = ctx.client_id,
  }

  local kind = "report"
  if result.complete then
    kind = "end"
  elseif result.workDone == 0 then
    kind = "begin"
  elseif result.workDone > 0 and result.workDone < result.totalWork then
    kind = "report"
  else
    kind = "end"
  end

  local percentage = 0
  if result.totalWork > 0 and result.workDone >= 0 then
    percentage = result.workDone / result.totalWork * 100
  end

  local msg = {
    token = result.id,
    value = {
      kind = kind,
      percentage = percentage,
      title = result.subTask,
      message = result.subTask,
    },
  }

  lsp.handlers["$/progress"](nil, msg, info)
end

local function get_workspace_folder()
  if utils.is_windows() then
    return path.join("C:/configurator-ide/jdtls/ws/", vim.fn.fnamemodify(root_dir, ":p:h:h:t"))
  else
    return path.join(
      home,
      path.sanitize("/.local/share/java/eclipse/"),
      vim.fn.fnamemodify(root_dir, ":p:h:h:t")
    )
  end
end

local debug_port = 5005

-- local java_bin = function() return  home .. "/.local/share/java/17/bin/java" .. get_executeable_file_exetension() end;
local function java_bin()
  return path.join(home, path.sanitize(".local/share/java/17/bin/java"))
end

local function configuration_path()
  if utils.is_windows() then
    return path.join(home, path.sanitize("/.local/share/java/jdtls/config_win"))
  else
    return home .. "/.local/share/java/jdtls/config_linux"
  end
end

local function get_runtimes()
  return {
    {
      name = "JavaSE-11",
      path = path.join(home, path.sanitize("/.local/share/java/11/")),
    },
    {
      name = "JavaSE-17",
      path = path.join(home, path.sanitize("/.local/share/java/17/")),
    },
  }
end

M = {}

function M.reload_target_platform()
  local uri = vim.uri_from_fname("m.model/merlin.model.runtime/merlin.model.runtime.target")
  print(uri)
  execute_command({
    command = "java.pde.reloadTargetPlatform",
    arguments = { uri },
  })
end

function M.launch_pde()
  local uri = vim.uri_from_fname("git/m.model/merlin.model.product/MModel.product.launch")
  local callback = function(error, response)
    if error ~= nil then
      print(vim.inspect(error))
    else
      print(vim.inspect(response))
    end
  end
  execute_command({ command = "java.pde.resolveLaunchArguments", arguments = { uri } }, callback)
end


local dap = require("dap")
dap.configurations.java = {
  {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = debug_port,
  },
}

local config = {
  flags = { debounce_text_changes = 80, allow_incremental_sync = true },
  handlers = {
    ["language/status"] = function() end,
    ["language/progressReport"] = progress_report,
  },
}

config.settings = {
  java = {
    signatureHelp = { enabled = true },
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
      organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      hashCodeEquals = { useJava7Objects = true },
      useBlocks = true,
    },
    format = {
      settings = {
        url = path.join(root_dir, ".merlin-java-formatter-profile.xml"),
      },
    },
    configuration = {
      runtimes = get_runtimes(),
      maven = {
        userSettings = "./maven/settings.xml",
        globalSettings = "./maven/settings.xml",
      },
    },
  },
}
config.cmd = {
  java_bin(),
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xmx4g",
  "-Xms1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
  "-jar",
  vim.fn.glob(
    path.join(
      home,
      path.sanitize("/.local/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
    )
  ),
  "-configuration",
  configuration_path(),
  "-data",
  get_workspace_folder(),
}
config.on_attach = function(client, bufnr)
  require("ld.lsp.remaps").set_default(client, bufnr, true)
  -- require("ld.lsp.settings").on_attach(client, bufnr, true)
  -- require("ld.lsp.settings").on_attach(client, bufnr, { server_side_fuzzy_completion = true })

  jdtls.setup_dap({ hotcodereplace = "auto" })
  require("jdtls.setup").add_commands()
  local opts = { silent = true, buffer = bufnr }
  -- vim.keymap.set("n", "<A-o>", jdtls.organize_imports, opts)
  -- vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)
  -- vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
  -- vim.keymap.set("n", "crv", jdtls.extract_variable, opts)
  -- vim.keymap.set("v", "crm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
  -- vim.keymap.set("n", "crc", jdtls.extract_constant, opts)

  -- local create_command = vim.api.nvim_buf_create_user_command
  -- create_command(bufnr, "W", require("me.lsp.ext").remove_unused_imports, { nargs = 0 })
end

local jar_patterns = {
  "/.local/share/java/jdtls-extensions/vscode-java-debug/extension/server/com.microsoft.java.debug.plugin-*.jar",
  "/.local/share/java/jdtls-extensions/vscode-java-test/extension/server/*.jar",
  "/.local/share/java/jdtls-extensions/vscode-pde-support/extension/server/*.jar",
}
-- local plugin_path = "/.local/share/java/jdtls-extensions/vscode-java-test/extension/server/*.jar",
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
  for _, bundle in ipairs(vim.split(vim.fn.glob(path.join(home, path.sanitize(jar_pattern))), "\n")) do
    if
      not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
      and not vim.endswith(bundle, "com.microsoft.java.test.runner.jar")
    then
      table.insert(bundles, bundle)
    end
  end
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
  bundles = bundles,
  extendedClientCapabilities = extendedClientCapabilities,
}

function M.jdtls_start_or_attach()
  jdtls.start_or_attach(config)
end

return M
