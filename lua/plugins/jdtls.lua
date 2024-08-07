return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
        local jdtls = require('jdtls')
        local jdtls_dap = require("jdtls.dap")
        local jdtls_setup = require("jdtls.setup")
        local home = os.getenv('HOME')
        local extendedClientCapabilities = jdtls.extendedClientCapabilities
        local bundles = {
            vim.fn.glob(
                home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
                true),
        }

        vim.list_extend(bundles,
            vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", true), "\n"))
        local config = {
            -- The command that starts the language server
            -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
            cmd = {
                -- home .. "/.sdkman/candidates/java/22.0.2-oracle/bin/java",
                "/usr/local/Cellar/openjdk@11/11.0.24/libexec/openjdk.jdk/Contents/Home/bin/java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx1g",
                '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
                -- "--jvm-arg=" .. string.format(
                --     "-javaagent:%s", home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"),
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-jar",
                home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
                "-configuration",
                home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
                "-data",
                home .. "/IdeaProjects/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
            },
            root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

            -- Here you can configure eclipse.jdt.ls specific settings
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- for a list of options
            settings = {
                java = {
                    references = { includeDecompiledSources = true, },
                    referencesCodeLens = { enabled = true, },
                    eclipse = { downloadSources = true, },
                    maven = { downloadSources = true, },
                    signatureHelp = { enabled = true },
                    contentProvider = { preferred = "fernflower" },
                    extendedClientCapabilities = extendedClientCapabilities,
                    inlayHints = {
                        parameterNames = {
                            enabled = 'all', -- literals, all, none
                        },
                    },
                    format = {
                        enabled = true,
                        settings = {
                            url = home .. "/code_style.xml",
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
                    runtimes = {
                        {
                            name = "java-11-openjdk",
                            path = "/usr/local/Cellar/openjdk@11/11.0.24/libexec/openjdk.jdk/Contents/Home/bin/java",
                        },
                        {
                            name = "java-22-openjdk",
                            path = home .. "/.sdkman/candidates/java/22.0.2-oracle/bin/java",
                        }
                    },
                }
            },
            -- on_attach = function(client, bufnr)
            --     jdtls.setup_dap({ hotcodereplace = "auto" })
            --     jdtls_dap.setup_dap_main_class_configs()
            --     jdtls_setup.add_commands()
            --
            --     -- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L88-L94
            --     local opts = { silent = true, buffer = bufnr }
            --     vim.keymap.set('n', "gH", jdtls.organize_imports, opts)
            --     vim.keymap.set('n', "<leader>Tc", jdtls.test_class, opts)
            --     vim.keymap.set('n', "<leader>Tm", jdtls.test_nearest_method, opts)
            --     vim.keymap.set('n', '<leader>rv', jdtls.extract_variable_all, opts)
            --     vim.keymap.set('v', '<leader>rm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
            --     vim.keymap.set('n', '<leader>rc', jdtls.extract_constant, opts)
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

        jdtls.start_or_attach(config)

        local opts = { silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>jco', "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
        vim.keymap.set('n', '<leader>jcrv', "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
        vim.keymap.set('v', '<leader>jcrv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
        vim.keymap.set('n', '<leader>jcrc', "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
        vim.keymap.set('v', '<leader>jcrc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
        vim.keymap.set('v', '<leader>jcrm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
    end,
}

-- return {
--     "mfussenegger/nvim-jdtls",
--     ft = { "java" },
--     config = function()
--         local jdtls = require('jdtls')
--         local jdtls_dap = require("jdtls.dap")
--         local jdtls_setup = require("jdtls.setup")
--         local home = os.getenv('HOME')
--         local extendedClientCapabilities = jdtls.extendedClientCapabilities
--         local bundles = {
--             vim.fn.glob(
--                 home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
--                 true),
--         }
--
--         vim.list_extend(bundles,
--             vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))
--         local config = {
--             -- The command that starts the language server
--             -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
--             cmd = {
--                 -- home .. "/.sdkman/candidates/java/22.0.2-oracle/bin/java",
--                 "/usr/local/Cellar/openjdk@11/11.0.24/libexec/openjdk.jdk/Contents/Home/bin/java",
--                 "-Declipse.application=org.eclipse.jdt.ls.core.id1",
--                 "-Dosgi.bundles.defaultStartLevel=4",
--                 "-Declipse.product=org.eclipse.jdt.ls.core.product",
--                 "-Dlog.protocol=true",
--                 "-Dlog.level=ALL",
--                 "-Xmx1g",
--                 '-javaagent:' .. home .. '/.local/share/nvim/mason/share/jdtls/lombok.jar',
--                 -- "--jvm-arg=" .. string.format(
--                 --     "-javaagent:%s", home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"),
--                 "--add-modules=ALL-SYSTEM",
--                 "--add-opens",
--                 "java.base/java.util=ALL-UNNAMED",
--                 "--add-opens",
--                 "java.base/java.lang=ALL-UNNAMED",
--                 "-jar",
--                 home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
--                 "-configuration",
--                 home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
--                 "-data",
--                 -- home .. "/IdeaProjects/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
--                 home .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
--             },
--             root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
--
--             -- Here you can configure eclipse.jdt.ls specific settings
--             -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
--             -- for a list of options
--             settings = {
--                 java = {
--                     references = { includeDecompiledSources = true, },
--                     referencesCodeLens = { enabled = true, },
--                     eclipse = { downloadSources = true, },
--                     maven = { downloadSources = true, },
--                     signatureHelp = { enabled = true },
--                     contentProvider = { preferred = "fernflower" },
--                     extendedClientCapabilities = extendedClientCapabilities,
--                     inlayHints = {
--                         parameterNames = {
--                             enabled = 'all', -- literals, all, none
--                         },
--                     },
--                     format = {
--                         enabled = true,
--                         settings = {
--                             url = home .. "/code_style.xml",
--                             profile = "GoogleStyle",
--                         },
--                     },
--                     codeGeneration = {
--                         toString = {
--                             template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
--                         },
--                         useBlocks = true,
--                     },
--                 },
--                 configuration = {
--                     runtimes = {
--                         {
--                             name = "java-11-openjdk",
--                             path = "/usr/local/Cellar/openjdk@11/11.0.24/libexec/openjdk.jdk/Contents/Home/bin/java",
--                         },
--                         {
--                             name = "java-22-openjdk",
--                             path = home .. "/.sdkman/candidates/java/22.0.2-oracle/bin/java",
--                         }
--                     },
--                 }
--             },
--             capabilities = require("cmp_nvim_lsp").default_capabilities();
--             on_attach = function(client, bufnr)
--                 jdtls.setup_dap({ hotcodereplace = "auto" })
--                 jdtls_dap.setup_dap_main_class_configs()
--             end,
--             -- on_attach = function(client, bufnr)
--             --     jdtls.setup_dap({ hotcodereplace = "auto" })
--             --     jdtls_dap.setup_dap_main_class_configs()
--             --     jdtls_setup.add_commands()
--             --
--             --     -- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L88-L94
--             --     local opts = { silent = true, buffer = bufnr }
--             --     vim.keymap.set('n', "gH", jdtls.organize_imports, opts)
--             --     vim.keymap.set('n', "<leader>Tc", jdtls.test_class, opts)
--             --     vim.keymap.set('n', "<leader>Tm", jdtls.test_nearest_method, opts)
--             --     vim.keymap.set('n', '<leader>rv', jdtls.extract_variable_all, opts)
--             --     vim.keymap.set('v', '<leader>rm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
--             --     vim.keymap.set('n', '<leader>rc', jdtls.extract_constant, opts)
--             -- end,
--
--             -- Language server `initializationOptions`
--             -- You need to extend the `bundles` with paths to jar files
--             -- if you want to use additional eclipse.jdt.ls plugins.
--             --
--             -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
--             --
--             -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
--             init_options = {
--                 bundles = bundles,
--             },
--         }
--
--         jdtls.start_or_attach(config)
--
--         local opts = { silent = true, buffer = bufnr }
--         vim.keymap.set('n', '<leader>jco', "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
--         vim.keymap.set('n', '<leader>jcrv', "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
--         vim.keymap.set('v', '<leader>jcrv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
--         vim.keymap.set('n', '<leader>jcrc', "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
--         vim.keymap.set('v', '<leader>jcrc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
--         vim.keymap.set('v', '<leader>jcrm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
--     end,
-- }
