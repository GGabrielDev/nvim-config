return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 12
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      start_in_insert = true,
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 3,
        title_pos = "center",
      },
    })

    vim.keymap.set("n", "<leader>zz", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal split" })

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        local opts = { buffer = 0, noremap = true, silent = true }
        local keymap = vim.keymap

        keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end,
    })
  end,
}
