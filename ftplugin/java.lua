local home = os.getenv("HOME")
local jdtls = require("jdtls")

-- Find root of project (same priority as nvim-lspconfig)
-- Multi-module markers first, then single-module markers
local root_markers = { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" }
local root_dir = vim.fs.root(0, root_markers)

-- Fallback to single-module markers
if not root_dir then
  root_dir = vim.fs.root(0, { "build.xml", "pom.xml", "build.gradle", "build.gradle.kts" })
end

if not root_dir then
  return
end

-- Check if JDTLS already running for this project
local clients = vim.lsp.get_clients({ name = "jdtls" })
for _, client in ipairs(clients) do
  if client.config.root_dir == root_dir then
    vim.lsp.buf_attach_client(0, client.id)
    return
  end
end

-- Project name and workspace directories (like LazyVim)
local project_name = vim.fs.basename(root_dir)
local cache_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name
local workspace_dir = cache_dir .. "/workspace"
local config_dir = cache_dir .. "/config"

-- Use the wrapper script (handles Java version, OS config automatically)
local cmd = { vim.fn.exepath("jdtls") }

-- Add Lombok support (use Mason's bundled lombok.jar)
local lombok_jar = home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar"
if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
end

-- Add custom JVM args for Maven 3.6.3 (no HTTP blocker)
local maven_home = home .. "/.sdkman/candidates/maven/3.6.3"
if vim.fn.isdirectory(maven_home) == 1 then
  table.insert(cmd, string.format("--jvm-arg=-Dmaven.home=%s", maven_home))
end

-- Add more memory
table.insert(cmd, "--jvm-arg=-Xmx4g")

-- Add config and data directories
vim.list_extend(cmd, {
  "-configuration", config_dir,
  "-data", workspace_dir,
})

-- Debug and test bundles
local bundles = {}
local mason_share = home .. "/.local/share/nvim/mason/share"

-- Java Debug Adapter
local debug_jars = vim.fn.glob(mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", false, true)
if #debug_jars > 0 then
  vim.list_extend(bundles, debug_jars)
end

-- Java Test
local test_jars = vim.fn.glob(mason_share .. "/java-test/*.jar", false, true)
if #test_jars > 0 then
  vim.list_extend(bundles, test_jars)
end

-- Extended capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Java runtime configurations
local runtimes = {
  {
    name = "JavaSE-11",
    path = home .. "/.sdkman/candidates/java/11.0.28-amzn",
  },
  {
    name = "JavaSE-17",
    path = home .. "/.sdkman/candidates/java/17.0.13-tem",
  },
  {
    name = "JavaSE-21",
    path = home .. "/.sdkman/candidates/java/21.0.5-graal",
  },
  {
    name = "JavaSE-23",
    path = home .. "/.sdkman/candidates/java/23-graal",
  },
  {
    name = "JavaSE-24",
    path = home .. "/.sdkman/candidates/java/24.0.2-graalce",
  },
  {
    name = "JavaSE-25",
    path = home .. "/.sdkman/candidates/java/25.0.1-tem",
    default = true,
  },
}

-- LSP settings
local settings = {
  java = {
    configuration = {
      updateBuildConfiguration = "interactive",
      runtimes = runtimes,
      maven = {
        downloadSources = true,
        updateSnapshots = true,
        userSettings = home .. "/.m2/settings-jdtls.xml",
        globalSettings = home .. "/.m2/settings-jdtls.xml",
      },
    },
    eclipse = { downloadSources = true },
    maven = { downloadSources = true },
    implementationsCodeLens = { enabled = true },
    referencesCodeLens = { enabled = true },
    references = { includeDecompiledSources = true },
    signatureHelp = { enabled = true },
    contentProvider = { preferred = "fernflower" },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = { "java", "javax", "com", "org" },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
    inlayHints = {
      parameterNames = { enabled = "all" },
    },
    format = {
      enabled = true,
      settings = {
        url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
        profile = "GoogleStyle",
      },
    },
  },
}

-- Get capabilities from blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- JDTLS config
local config = {
  cmd = cmd,
  root_dir = root_dir,
  settings = settings,
  capabilities = capabilities,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
}

-- on_attach handler
config.on_attach = function(client, bufnr)
  -- Setup DAP
  jdtls.setup_dap({ hotcodereplace = "auto" })

  -- Enable inlay hints if supported
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Java-specific keymaps
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
  vim.keymap.set("n", "<leader>ju", jdtls.update_project_config, vim.tbl_extend("force", opts, { desc = "Update project config" }))

  -- Extract refactorings
  vim.keymap.set("n", "<leader>jrv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
  vim.keymap.set("v", "<leader>jrv", function() jdtls.extract_variable(true) end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
  vim.keymap.set("n", "<leader>jrc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
  vim.keymap.set("v", "<leader>jrc", function() jdtls.extract_constant(true) end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
  vim.keymap.set("v", "<leader>jrm", function() jdtls.extract_method(true) end, vim.tbl_extend("force", opts, { desc = "Extract method" }))

  -- Testing
  vim.keymap.set("n", "<leader>jtc", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Test class" }))
  vim.keymap.set("n", "<leader>jtm", jdtls.test_nearest_method, vim.tbl_extend("force", opts, { desc = "Test nearest method" }))

  -- Toggle inlay hints
  vim.keymap.set("n", "<leader>jh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))

  -- Super implementation
  vim.keymap.set("n", "<leader>jgs", jdtls.super_implementation, vim.tbl_extend("force", opts, { desc = "Go to super" }))
end

-- Start JDTLS
jdtls.start_or_attach(config)

-- User commands
vim.api.nvim_create_user_command("JdtUpdateConfig", jdtls.update_project_config, { desc = "Update JDTLS project configuration" })

vim.api.nvim_create_user_command("JdtStatus", function()
  local c = vim.lsp.get_clients({ name = "jdtls" })[1]
  if not c then
    vim.notify("JDTLS is not running!", vim.log.levels.ERROR)
    return
  end
  vim.notify(string.format("JDTLS Status:\n  ID: %d\n  Root: %s\n  Initialized: %s", c.id, c.config.root_dir, tostring(c.initialized)), vim.log.levels.INFO)
end, { desc = "Show JDTLS status" })
