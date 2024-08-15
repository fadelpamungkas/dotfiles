local jdtls = require("jdtls")
local home = os.getenv("HOME")
local bundles = {
	vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx4g",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_mac_arm",
		"-data",
		home .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
	},

	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "pom.xml", "build.gradle" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			home = home .. "/.sdkman/candidates/java/11.0.14.1-jbr",
			references = { includeDecompiledSources = true },
			referencesCodeLens = { enabled = true },
			implementationsCodeLens = { enabled = true },
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			extendedClientCapabilities = jdtls.extendedClientCapabilities,
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = true,
				settings = {
					url = home .. "/code_style_eclipse.xml",
					-- url = "file://" .. home .. "/code_style.xml",
					-- url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/intellij-java-google-style.xml",
					profile = "GoogleStyle",
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
		configuration = {
			updateBuildConfiguration = "interactive",
			runtimes = {
				{
					name = "JavaSE-11",
					path = home .. "/.sdkman/candidates/java/11.0.14.1-jbr",
				},
				{
					name = "java-22-openjdk",
					path = home .. "/.sdkman/candidates/java/22.0.2-graal",
				},
			},
		},
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	flags = { allow_incremental_sync = true },
	-- on_attach = function(client, bufnr)
	-- 	jdtls.setup_dap({ hotcodereplace = "auto" })
	-- 	jdtls_dap.setup_dap_main_class_configs()
	--
	-- 	-- jdtls_setup.add_commands()
	-- 	--
	-- 	-- -- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L88-L94
	-- 	-- local opts = { silent = true, buffer = bufnr }
	-- 	-- vim.keymap.set('n', "gH", jdtls.organize_imports, opts)
	-- 	-- vim.keymap.set('n', "<leader>Tc", jdtls.test_class, opts)
	-- 	-- vim.keymap.set('n', "<leader>Tm", jdtls.test_nearest_method, opts)
	-- 	-- vim.keymap.set('n', '<leader>rv', jdtls.extract_variable_all, opts)
	-- 	-- vim.keymap.set('v', '<leader>rm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
	-- 	-- vim.keymap.set('n', '<leader>rc', jdtls.extract_constant, opts)
	-- end,

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = bundles,
	},
}

config["on_attach"] = function(client, bufnr)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end

jdtls.start_or_attach(config)

local opts = {}
vim.keymap.set("n", "<leader>ju", "<Cmd>lua require('jdtls').update_projects_config()<CR>", opts)
vim.keymap.set("n", "<leader>jo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
vim.keymap.set("n", "<leader>jrV", "<Cmd>lua require('jdtls').extract_variable_all()<CR>", opts)
vim.keymap.set("n", "<leader>jrv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
vim.keymap.set("v", "<leader>jrv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
vim.keymap.set("n", "<leader>jrc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
vim.keymap.set("v", "<leader>jrc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
vim.keymap.set("v", "<leader>jrm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
vim.keymap.set("n", "<leader>jtc", "<Cmd>lua require('jdtls').test_class()<CR>", opts)
vim.keymap.set("n", "<leader>jtm", "<Cmd>lua require('jdtls').test_nearest_method()<CR>", opts)

vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

vim.keymap.set("n", "<leader>l", function()
	vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
end)
--
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
-- vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle<cr>", opts)
-- vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle<cr>", opts)
-- vim.keymap.set("n", "gL", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", opts)
-- vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
-- vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
-- vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
-- vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
