return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- 🛠 Configuración personalizada de eslint_d para evitar advertencias
    lint.linters.eslint_d = {
      cmd = "eslint_d",
      stdin = true,
      args = {
        "--no-warn-ignored",
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      },
      parser = function(output, bufnr)
        local ok, decoded = pcall(vim.json.decode, output)
        if not ok or not decoded or not decoded[1] then
          return {}
        end

        local diagnostics = {}
        for _, message in ipairs(decoded[1].messages or {}) do
          table.insert(diagnostics, {
            lnum = message.line - 1,
            col = message.column - 1,
            end_lnum = message.endLine and message.endLine - 1 or nil,
            end_col = message.endColumn and message.endColumn - 1 or nil,
            severity = message.severity == 2 and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
            source = "eslint_d",
            message = message.message,
            code = message.ruleId,
          })
        end
        return diagnostics
      end,
    }

    -- 🗂 Asociación de linters por tipo de archivo
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    -- ⚙️ Auto-lint en eventos comunes
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- ⌨️ Mapeo para linting manual
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
