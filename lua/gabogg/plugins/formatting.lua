return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local lint = require("lint")

    -- conform.formatters.eslint_d = {
    --   command = "eslint_d",
    --   args = {
    --     "--fix-to-stdout",
    --     "--stdin",
    --     "--stdin-filename",
    --     function(ctx)
    --       return ctx.filename
    --     end,
    --   },
    --   stdin = true,
    --   cwd = function(ctx)
    --     return vim.fs.dirname(
    --       vim.fs.find({ "eslint.config.js", "package.json" }, { upward = true, path = ctx.filename })[1]
    --         or vim.fn.getcwd()
    --     )
    --   end,
    --   condition = function(ctx)
    --     return vim.fs.find({
    --       "eslint.config.js",
    --       ".eslintrc.js",
    --       ".eslintrc.cjs",
    --       ".eslintrc.json",
    --     }, { upward = true, path = ctx.filename })[1] ~= nil
    --   end,
    -- }

    conform.setup({
      formatters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    -- After formatting on save, re-lint to update diagnostics
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.svelte" },
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
