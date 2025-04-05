-- Eclipse Java development tools (JDT) Language Server downloaded from:
-- https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.21.0/jdt-language-server-1.21.0-202303161431.tar.gz
local jdtls = require("jdtls")
-- Change or delete this if you don't depend on nvim-cmp for completions.
local utils = require("ld.utils.functions")
local path = require("ld.utils.path")

local home = vim.fn.getenv("HOME")

-- Change jdtls_path to wherever you have your Eclipse Java development tools (JDT) Language Server downloaded to.
local jdtls_path = path.join(home, path.sanitize("/.local/share/java/jdtls"))
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local workspace_dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local git_root = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true, type = "directory" })[1])
local root_dir = vim.fs.dirname(vim.fs.find({ "pom.xml", ".git" }, { upward = true })[1])

-- for completions
local capabilities = vim.lsp.protocol.make_client_capabilities()

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

local function get_config_dir()
  -- Unlike some other programming languages (e.g. JavaScript)
  -- lua considers 0 truthy!
  if vim.fn.has("linux") == 1 then
    return "config_linux"
  elseif vim.fn.has("mac") == 1 then
    return "config_mac"
  else
    return "config_win"
  end
end

local function get_java_bin()
  if utils.is_windows() then
    return path.join(vim.fn.getenv("JAVA_HOME"), "/bin/java")
  else
    return path.join(
      home,
      path.sanitize("/.local/share/java/eclipse/"),
      vim.fn.fnamemodify(root_dir, ":p:h:h:t")
    )
  end
end

function get_bundles()
  local bundles = {
    vim.fn.glob(
      vim.fs.normalize(
        "~/.local/share/java/jdtls-extensions/vscode-java-debug/**/com.microsoft.java.debug.plugin-*.jar"
      ),
      1
    ),
  }
  vim.list_extend(
    bundles,
    vim.split(
      vim.fn.glob(
        vim.fs.normalize("~/.local/share/java/jdtls-extensions/vscode-java-test/server/*.jar"),
        1
      ),
      "\n"
    )
  )
  vim.list_extend(
    bundles,
    vim.split(
      vim.fn.glob(
        vim.fs.normalize("~/.local/share/java/jdtls-extensions/vscode-pde-support/server/*.jar"),
        1
      ),
      "\n"
    )
  )
  return bundles
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  capabilities = capabilities,
  cmd = {
    -- This sample path was tested on Cygwin, a "unix-like" Windows environment.
    -- Please contribute to this Wiki if this doesn't work for another Windows
    -- environment like [Git for Windows](https://gitforwindows.org/) or PowerShell.
    -- JDTLS currently needs Java 17 to work, but you can replace this line with "java"
    -- if Java 17 is on your PATH.
    get_java_bin(),
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
    launcher_jar,
    "-configuration",
    vim.fs.normalize(jdtls_path .. "/" .. get_config_dir()),
    "-data",
    -- vim.fn.expand("~/.cache/jdtls-workspace/") .. workspace_dir_name,
    vim.fs.normalize(
      path.join(path.join(vim.fs.dirname(git_root), "jdtls-ws"), workspace_dir_name)
    ),
  },
  root_dir = root_dir,
  settings = {
    java = {
      autobuild = {
        enabled = false,
      },
      -- project = {
      --   referencedLibraries = {
      --     vim.fs.normalize("~/.m2/repository/com/aspose/aspose-cells/22.3/aspose-cells-22.3.jar"),
      --     vim.fs.normalize("~/.m2/repository/com/aspose/aspose-cells/21.5/aspose-cells-21.5.jar"),
      --     vim.fs.normalize(
      --       "~/.m2/repository/com/aspose/aspose-words/22.2/aspose-words-22.2-jdk17.jar"
      --     ),
      --   },
      -- },
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
          url = "./.merlin-java-formatter-profile.xml",
        },
      },
      configuration = {
        -- runtimes = get_runtimes(),
        maven = {
          userSettings = path.to_os_path(path.join(git_root, "maven/settings.xml")),
          globalSettings = path.to_os_path(path.join(git_root, "maven/settings.xml")),
        },
      },
      compile = {
        nullAnalysis = {
          nonnull = {},
          nullable = {},
        },
      },
      import = {
        generatesMetadataFilesAtProjectRoot = true,
        -- exclusions = {
        --   "**/node_modules/**",
        --   "**/.metadata/**",
        --   "**/archetype-resources/**",
        --   "**/META_INF/maven/**",
        -- },
      },
    },
  },
  flags = { debounce_text_changes = 80, allow_incremental_sync = true },
  handlers = {
    ["language/status"] = function() end,
    ["language/progressReport"] = progress_report,
  },
  init_options = {
    -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Language-Server-Settings-&-Capabilities#extended-client-capabilities
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    bundles = get_bundles(),
  },
  on_attach = function(client, bufnr)

    -- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L88-L94
    -- local opts = { silent = true, buffer = bufnr }
    -- vim.keymap.set(
    --   "n",
    --   "<leader>lo",
    --   jdtls.organize_imports,
    --   { desc = "Organize imports", buffer = bufnr }
    -- )
    -- -- Should 'd' be reserved for debug?
    -- vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)
    -- vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
    -- vim.keymap.set(
    --   "n",
    --   "<leader>rv",
    --   jdtls.extract_variable_all,
    --   { desc = "Extract variable", buffer = bufnr }
    -- )
    -- vim.keymap.set(
    --   "v",
    --   "<leader>rm",
    --   [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    --   { desc = "Extract method", buffer = bufnr }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   "<leader>rc",
    --   jdtls.extract_constant,
    --   { desc = "Extract constant", buffer = bufnr }
    -- )
  end,
}

M = {}

function M.jdtls_start_or_attach()
  -- jdtls.start_or_attach(config)
end

return M
