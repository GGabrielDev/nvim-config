return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local jdtls = require("jdtls")

    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    require("neodev").setup({
      -- add any options here
    })

    local root_markers = { ".git", "mvnw", "gradlew" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    if root_dir == nil then
      return
    end

    local home = os.getenv("HOME")
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

    -- Find the extra bundles that were installed by mason-tool-installer
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    local bundles = {
      vim.fn.glob(mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
    }
    vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "/packages/java-test/server/*.jar"), "\n"))

    local config = {
      cmd = { "jdtls" },
      root_dir = root_dir,
      workspace_dir = workspace_dir,
      settings = {
        java = {
          -- jdtls = {
          --   ls = {
          --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1g -Xms100m",
          --   },
          -- },
          -- signatureHelp = { enabled = true },
          -- contentProvider = { preferred = "fernflower" },
          -- completion = {
          --   favoriteStaticMembers = {
          --     "org.hamcrest.MatcherAssert.assertThat",
          --     "org.hamcrest.Matchers.*",
          --     "org.junit.jupiter.api.Assertions.*",
          --     "java.util.Objects.requireNonNull",
          --     "java.util.Objects.requireNonNullElse",
          --     "org.mockito.Mockito.*",
          --   },
          -- },
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
          -- debug = {
          --   settings = {
          --     -- java = {
          --     --   -- Debug settings go here
          --     -- },
          --   },
          -- },
          -- implementationsCodeLens = {
          --   enabled = true,
          -- },
          -- referencesCodeLens = {
          --   enabled = true,
          -- },
          -- format = {
          --   enabled = true,
          --   -- settings = {
          --   --   -- url = home .. "/.config/nvim/codestyle/google-style.xml",
          --   --   -- profile = "GoogleStyle",
          --   -- },
          -- },
        },
      },
      init_options = {
        bundles = bundles,
        extendedClientCapabilities = extendedClientCapabilities,
      },
    }

    jdtls.start_or_attach(config)

    -- Keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>jt", function() jdtls.test_nearest_method() end, { desc = "Run the nearest test method" })
    keymap.set("n", "<leader>jT", function() jdtls.test_class() end, { desc = "Run the current test class" })
    keymap.set("n", "<leader>jr", "<Cmd>JavaRunnerRunMain<CR>", { desc = "Run the main class" })
  end,
}
