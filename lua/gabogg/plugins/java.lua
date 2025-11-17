return {
  'nvim-java/nvim-java',
  dependencies = {
    'nvim-java/lua-async-await',
    'nvim-java/nvim-java-core',
    'nvim-java/nvim-java-test',
    'nvim-java/nvim-java-dap',
    'MunifTanjim/nui.nvim',
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'williamboman/mason.nvim',
  },
  config = function()
    local keymap = vim.keymap

    keymap.set('n', '<leader>jt', ':JavaTestCurrentMethod<CR>', { desc = "Run the current test method" })
    keymap.set('n', '<leader>jT', ':JavaTestCurrentClass<CR>', { desc = "Run the current test class" })
    keymap.set('n', '<leader>jr', ':JavaRunnerRunMain<CR>', { desc = "Run the main class" })
  end,
}
